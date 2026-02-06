<?php

namespace App\Controller;

use App\Repository\TweetsRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

class ProfileController extends AbstractController
{
    #[Route('/profile', name: 'app_profile')]
    #[IsGranted('ROLE_USER')]
    public function myProfile(TweetsRepository $tweetsRepository): Response
    {
        $user = $this->getUser();


        $tweets = $tweetsRepository->findBy(
            ['author' => $user],
            ['createdAt' => 'DESC']
        );

        return $this->render('profile/my_profile.html.twig', [
            'user' => $user,
            'tweets' => $tweets,
        ]);
    }
}
