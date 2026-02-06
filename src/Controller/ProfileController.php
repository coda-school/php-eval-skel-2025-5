<?php

namespace App\Controller;

use App\Repository\TweetsRepository;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_USER')]
class ProfileController extends AbstractController
{
    #[Route('/profile', name: 'app_profile')]
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

    #[Route('/profile/update-bio', name: 'app_profile_update_bio', methods: ['POST'])]
    public function updateBio(Request $request, EntityManagerInterface $em): Response
    {
        $user = $this->getUser();
        $user->setBio($request->request->get('bio'));
        $em->flush();

        return $this->redirectToRoute('app_profile');
    }

    #[Route('/profile/update-username', name: 'app_profile_update_username', methods: ['POST'])]
    public function updateUsername(Request $request, EntityManagerInterface $em, UserRepository $userRepository): Response
    {
        $user = $this->getUser();
        $newUsername = $request->request->get('username');

        if ($newUsername && $newUsername !== $user->getUserIdentifier()) {
            if (!$userRepository->findOneBy(['username' => $newUsername])) {
                $user->setUsername($newUsername);
                $em->flush();
            }
        }

        return $this->redirectToRoute('app_profile');
    }
}
