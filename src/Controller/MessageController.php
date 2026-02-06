<?php

namespace App\Controller;

use App\Entity\Message;
use App\Entity\User;
use App\Form\MessageType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class MessageController extends AbstractController
{
    #[Route('/messages', name: 'app_inbox')]
    public function index(): Response
    {
        // Get the currently logged-in user
        $user = $this->getUser();

        // Ensure user is logged in
        if (!$user) { return $this->redirectToRoute('app_login'); }

        // TODO: In the twig template, we will loop through user.receivedMessages
        return $this->render('message/index.html.twig', [
            'user' => $user,
        ]);
    }

    #[Route('/message/send/{id}', name: 'app_message_send')]
    public function send(User $recipient, Request $request, EntityManagerInterface $em): Response
    {
        $message = new Message();
        $form = $this->createForm(MessageType::class, $message);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            // 1. Set the Sender (You)
            $message->setSender($this->getUser());

            // 2. Set the Receiver (The person you clicked on)
            $message->setReceiver($recipient);

            // 3. Set the Timestamp
            $message->setCreatedAt(new \DateTimeImmutable());

            // 4. Save to Database
            $em->persist($message);
            $em->flush();

            $this->addFlash('success', 'Message sent!');
            return $this->redirectToRoute('app_inbox');
        }

        return $this->render('message/send.html.twig', [
            'form' => $form->createView(),
            'recipient' => $recipient
        ]);
    }
}
