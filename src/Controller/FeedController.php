<?php

namespace App\Controller;

use App\Repository\TweetsRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;


final class FeedController extends AbstractController
{
    // src/Controller/FeedController.php

    #[Route('/feed', name: 'app_feed')]
    #[IsGranted('ROLE_USER')]
    public function index(
        Request $request,
        TweetsRepository $tweetRepository
    ): Response {
        $user = $this->getUser();

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
            'page' => $page
        ]);
    }

}
