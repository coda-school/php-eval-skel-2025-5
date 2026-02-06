<?php

namespace App\Controller;

use App\Entity\Tweets;
use App\Repository\TweetsRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_USER')]
final class FeedController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    #[Route('/feed', name: 'app_feed', methods: ['GET', 'POST'])]
    public function index(
        Request $request,
        TweetsRepository $tweetRepository,
        EntityManagerInterface $em
    ): Response {
        $user = $this->getUser();

        if ($request->isMethod('POST') && $request->request->get('content')) {
            $tweet = new Tweets();
            $tweet->setContent($request->request->get('content'));
            $tweet->setAuthor($user);
            $tweet->setCreatedAt(new \DateTimeImmutable());

            $em->persist($tweet);
            $em->flush();

            return $this->redirectToRoute('app_feed');
        }

        $tweets = $tweetRepository->findBy([], ['createdAt' => 'DESC']);

        return $this->render('feed/index.html.twig', [
            'tweets' => $tweets,
        ]);
    }

    #[Route('/feed/edit/{id}', name: 'app_tweet_edit', methods: ['GET', 'POST'])]
    public function edit(Tweets $tweet, Request $request, EntityManagerInterface $em): Response
    {
        if ($tweet->getAuthor() !== $this->getUser()) {
            throw $this->createAccessDeniedException("Vous ne pouvez pas modifier ce tweet.");
        }

        if ($request->isMethod('POST')) {
            $content = $request->request->get('content');
            if ($content) {
                $tweet->setContent($content);
                $em->flush();
                return $this->redirectToRoute('app_feed');
            }
        }

        return $this->render('feed/edit.html.twig', [
            'tweet' => $tweet,
        ]);
    }

    #[Route('/feed/delete/{id}', name: 'app_tweet_delete', methods: ['POST'])]
    public function delete(Tweets $tweet, EntityManagerInterface $em, Request $request): Response
    {
        if ($tweet->getAuthor() !== $this->getUser()) {
            throw $this->createAccessDeniedException("Vous ne pouvez pas supprimer ce tweet.");
        }

        if ($this->isCsrfTokenValid('delete'.$tweet->getId(), $request->request->get('_token'))) {
            $em->remove($tweet);
            $em->flush();
        }

        return $this->redirectToRoute('app_feed');
    }
    #[Route('/profile/update-email', name: 'app_profile_update_email', methods: ['POST'])]
    #[IsGranted('ROLE_USER')]
    public function updateEmail(Request $request, EntityManagerInterface $em, UserRepository $userRepository): Response
    {
        /** @var \App\Entity\User $user */
        $user = $this->getUser();
        $newEmail = $request->request->get('email');

        if ($newEmail && $newEmail !== $user->getEmail()) {
            $existingUser = $userRepository->findOneBy(['email' => $newEmail]);

            if ($existingUser) {
                $this->addFlash('error', 'Cet email est déjà associé à un autre compte.');
            } else {
                $user->setEmail($newEmail);
                $em->flush();
                $this->addFlash('success', 'Email mis à jour !');
            }
        }

        return $this->redirectToRoute('app_profile');
    }
}

