<?php

namespace App\Repository;

use App\Entity\Follows;
use App\Entity\Tweets;
use App\Entity\User;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Tweets>
 */
class TweetsRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Tweets::class);
    }

    public function findFeedForUser(
        ?User $user,
        int $limit,
        int $offset
    ): array {
        if ($user === null) {
            return [];
        }

        return $this->createQueryBuilder('t')
            ->join('t.author', 'a')
            ->leftJoin(
                Follows::class,
                'f',
                'WITH',
                'f.following = a AND f.followers = :user'
            )
            ->where('f.id IS NOT NULL OR a = :user')
            ->setParameter('user', $user)
            ->orderBy('t.createdAt', 'DESC')
            ->setMaxResults($limit)
            ->setFirstResult($offset)
            ->getQuery()
            ->getResult();
    }



//    /**
//     * @return Tweets[] Returns an array of Tweets objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('t')
//            ->andWhere('t.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('t.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?Tweets
//    {
//        return $this->createQueryBuilder('t')
//            ->andWhere('t.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }
}
