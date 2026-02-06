<?php

namespace App\Controller;

use App\Entity\Message;
use App\Entity\User;
use App\Form\MessageType;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class MessageController extends AbstractController
{
    #[Route('/messages', name: 'app_inbox')]
    public function index(UserRepository $userRepository): Response
    {
        $user = $this->getUser();
        if (!$user) { return $this->redirectToRoute('app_login'); }

        $users = $userRepository->findAll();

        return $this->render('message/index.html.twig', [
            'user' => $user,
            'users' => $users,
        ]);
    }

    #[Route('/message/send/{id}', name: 'app_message_send')]
    public function send(User $recipient, Request $request, EntityManagerInterface $em): Response
    {
        $user = $this->getUser();
        if (!$user) { return $this->redirectToRoute('app_login'); }

        $message = new Message();
        $content = $request->request->get('content');

        if ($request->isMethod('POST') && $content) {
            $message->setSender($user);
            $message->setReceiver($recipient);
            $message->setContent($content);
            $message->setCreatedAt(new \DateTimeImmutable());

            $em->persist($message);
            $em->flush();

            $this->addFlash('success', 'Message envoyé !');
            return $this->redirectToRoute('app_inbox');
        }

        return $this->render('message/send.html.twig', [
            'recipient' => $recipient
        ]);
    }
}
