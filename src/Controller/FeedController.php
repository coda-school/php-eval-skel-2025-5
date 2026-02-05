<?php

namespace App\Controller;

use App\Entity\User;
use App\Entity\Tweets;
use App\Form\TweetsType;
use App\Repository\TweetsRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;
use Doctrine\ORM\EntityManagerInterface;


final class FeedController extends AbstractController
{
    // src/Controller/FeedController.php

    #[Route('/feed', name: 'app_feed')]
    #[IsGranted('ROLE_USER')]
    public function index(
        Request $request,
        TweetsRepository $tweetRepository,
        EntityManagerInterface $entityManager
    ): Response {
        $user = $this->getUser();
        if (!$user instanceof User) {
            throw $this->createAccessDeniedException('User must be an App\\Entity\\User.');
        }

        $tweet = new Tweets();
        $form = $this->createForm(TweetsType::class, $tweet);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $tweet->setAuthor($user);
            $tweet->setCreatedAt(new \DateTimeImmutable());

            $entityManager->persist($tweet);
            $entityManager->flush();

            return $this->redirectToRoute('app_feed');
        }

        $page = max(1, $request->query->getInt('page', 1));
        $limit = 10;
        $offset = ($page - 1) * $limit;

        $tweets = $tweetRepository->findFeedForUser(
            $user,
            $limit,
            $offset
        );

        return $this->render('feed/index.html.twig', [
            'tweets' => $tweets,
            'tweetForm' => $form->createView(),
        ]);
    }

}
