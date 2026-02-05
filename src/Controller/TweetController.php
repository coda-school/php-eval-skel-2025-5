<?php

namespace App\Controller;

use App\Entity\Tweets;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

class TweetController extends AbstractController
{
    #[Route('/tweet/{id}/delete', name: 'tweet_delete', methods: ['POST'])]
    #[IsGranted('ROLE_USER')]
    public function delete(
        Tweets $tweet,
        EntityManagerInterface $entityManager
    ): Response {
        if ($tweet->getAuthor() !== $this->getUser()) {
            throw $this->createAccessDeniedException();
        }

        $entityManager->remove($tweet);
        $entityManager->flush();

        return $this->redirectToRoute('app_feed');
    }
}

