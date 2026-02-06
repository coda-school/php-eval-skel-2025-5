-- =========================================
-- SUPPRESSION DES TABLES (si elles existent)
-- =========================================

DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS tweets;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS users;

-- =========================================
-- TABLE UTILISATEURS
-- =========================================

CREATE TABLE users (
id BIGINT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(50) NOT NULL UNIQUE,
email VARCHAR(255) NOT NULL UNIQUE,
password_hash VARCHAR(255) NOT NULL,
bio VARCHAR(160),
avatar_url VARCHAR(255),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- TABLE TWEETS
-- =========================================

CREATE TABLE tweets (
id BIGINT PRIMARY KEY AUTO_INCREMENT,
user_id BIGINT NOT NULL,
content VARCHAR(280) NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
deleted_at TIMESTAMP NULL,
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_tweets_user_date ON tweets(user_id, created_at DESC);

-- =========================================
-- TABLE FOLLOWS
-- =========================================

CREATE TABLE follows (
                         follower_id BIGINT NOT NULL,
                         following_id BIGINT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         PRIMARY KEY (follower_id, following_id),
                         FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
                         FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =========================================
-- TABLE LIKES
-- =========================================

CREATE TABLE likes (
user_id BIGINT NOT NULL,
tweet_id BIGINT NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (user_id, tweet_id),
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
FOREIGN KEY (tweet_id) REFERENCES tweets(id) ON DELETE CASCADE
);

-- =========================================
-- TABLE COMMENTS
-- =========================================

CREATE TABLE comments (
id BIGINT PRIMARY KEY AUTO_INCREMENT,
tweet_id BIGINT NOT NULL,
user_id BIGINT NOT NULL,
content VARCHAR(280) NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (tweet_id) REFERENCES tweets(id) ON DELETE CASCADE,
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =========================================
-- INSERT UTILISATEURS (20)
-- =========================================

INSERT INTO users (id, username, email, password_hash, bio, avatar_url) VALUES
(1, 'alice', 'alice@mail.com', 'hash1', 'Bio de Alice', NULL),
(2, 'bob', 'bob@mail.com', 'hash2', 'Bio de Bob', NULL),
(3, 'charlie', 'charlie@mail.com', 'hash3', 'Bio de Charlie', NULL),
(4, 'david', 'david@mail.com', 'hash4', 'Bio de David', NULL),
(5, 'emma', 'emma@mail.com', 'hash5', 'Bio de Emma', NULL),
(6, 'felix', 'felix@mail.com', 'hash6', 'Bio de Felix', NULL),
(7, 'grace', 'grace@mail.com', 'hash7', 'Bio de Grace', NULL),
(8, 'henry', 'henry@mail.com', 'hash8', 'Bio de Henry', NULL),
(9, 'irene', 'irene@mail.com', 'hash9', 'Bio de Irene', NULL),
(10, 'jack', 'jack@mail.com', 'hash10', 'Bio de Jack', NULL),
(11, 'karen', 'karen@mail.com', 'hash11', 'Bio de Karen', NULL),
(12, 'leo', 'leo@mail.com', 'hash12', 'Bio de Leo', NULL),
(13, 'mia', 'mia@mail.com', 'hash13', 'Bio de Mia', NULL),
(14, 'nathan', 'nathan@mail.com', 'hash14', 'Bio de Nathan', NULL),
(15, 'olivia', 'olivia@mail.com', 'hash15', 'Bio de Olivia', NULL),
(16, 'paul', 'paul@mail.com', 'hash16', 'Bio de Paul', NULL),
(17, 'quinn', 'quinn@mail.com', 'hash17', 'Bio de Quinn', NULL),
(18, 'rose', 'rose@mail.com', 'hash18', 'Bio de Rose', NULL),
(19, 'sam', 'sam@mail.com', 'hash19', 'Bio de Sam', NULL),
(20, 'tina', 'tina@mail.com', 'hash20', 'Bio de Tina', NULL);

-- =========================================
-- INSERT TWEETS (0 à 5 par utilisateur)
-- =========================================

INSERT INTO tweets (user_id, content) VALUES
-- Alice (3)
(1, 'Bonjour Twitter alternatif 👋'),
(1, 'Premier projet full stack, hype !'),
(1, 'Le café avant le code ☕'),

-- Bob (1)
(2, 'Hello world.'),

-- Charlie (5)
(3, 'JavaScript ou PHP ?'),
(3, 'Les API REST c’est la vie'),
(3, 'Encore un bug…'),
(3, 'Mais ça compile 😎'),
(3, 'Time for commit'),

-- Emma (2)
(5, 'UX > tout'),
(5, 'Un bon design vaut mille mots'),

-- Felix (4)
(6, 'Refactor time'),
(6, 'Clean code only'),
(6, 'SOLID principles'),
(6, 'Design patterns'),

-- Grace (1)
(7, 'React ou Vue ?'),

-- Irene (3)
(9, 'SQL bien structuré = perf'),
(9, 'Les index sauvent des vies'),
(9, 'Normalisation ❤️'),

-- Jack (2)
(10, 'Backend day'),
(10, 'API terminée'),

-- Karen (5)
(11, 'Tests unitaires'),
(11, 'Tests fonctionnels'),
(11, 'Tests E2E'),
(11, 'Coverage 100%'),
(11, 'Ship it'),

-- Mia (4)
(13, 'CSS is art'),
(13, 'Flexbox forever'),
(13, 'Grid aussi'),
(13, 'Dark mode obligatoire'),

-- Nathan (1)
(14, 'Déploiement en prod'),

-- Olivia (2)
(15, 'Sécurité avant tout'),
(15, 'Hash des mots de passe'),

-- Paul (3)
(16, 'Pagination done'),
(16, 'Infinite scroll'),
(16, 'Optimisation SQL'),

-- Rose (1)
(18, 'Projet validé 🎉'),

-- Sam (5)
(19, 'Alternative à Twitter en cours'),
(19, 'Base de données prête'),
(19, 'Seed SQL ok'),
(19, 'Backend next'),
(19, 'Frontend soon'),

-- Tina (2)
(20, 'Notifications système'),
(20, 'MP bientôt dispo');


-- =========================================
-- TABLE MESSAGES (MP)
-- =========================================

CREATE TABLE message (
                         id BIGINT PRIMARY KEY AUTO_INCREMENT,
                         sender_id BIGINT NOT NULL,
                         receiver_id BIGINT NOT NULL,
                         content TEXT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (sender_id) REFERENCES users (id) ON DELETE CASCADE,
                         FOREIGN KEY (receiver_id) REFERENCES users (id) ON DELETE CASCADE
);
-- =========================================
-- INSERT MESSAGES (Conversations de test)
-- =========================================

INSERT INTO message (sender_id, receiver_id, content, created_at) VALUES
(1, 2, 'Salut Bob ! Tu en es où sur le projet Symfony ?', NOW() - INTERVAL '1 hour'),
(2, 1, 'Hello Alice ! Je viens de finir de corriger les entités. Ça avance bien.', NOW() - INTERVAL '50 minute'),
(1, 2, 'Super ! On se fait une session de debug cet après-midi ?', NOW() - INTERVAL '45 minute'),
(2, 1, 'Carrément, disons 14h sur Discord.', NOW() - INTERVAL '40 minute'),

(3, 1, 'Dis Alice, tu préfères Tailwind ou Bootstrap pour le style ?', NOW() - INTERVAL '2 hour'),
(1, 3, 'Tailwind sans hésiter, c''est beaucoup plus flexible !', NOW() - INTERVAL '1 hour 50 minute'),

(19, 20, 'Le seed SQL est enfin prêt. Tu peux tester les MP ?', NOW() - INTERVAL '30 minute'),
(20, 19, 'Je regarde ça tout de suite ! Je t''envoie un message si je vois un bug.', NOW() - INTERVAL '25 minute'),
(19, 20, 'Nickel, merci Tina.', NOW() - INTERVAL '20 minute'),

(5, 1, 'Ton design est vraiment top, bien joué !', NOW() - INTERVAL '5 hour'),
(13, 15, 'Tu as pensé à hacher les mots de passe avant le commit ?', NOW() - INTERVAL '4 hour'),
(15, 13, 'Oui, j''ai utilisé password_hash() en PHP, c''est sécurisé.', NOW() - INTERVAL '3 hour');

CREATE INDEX idx_messages_conversation ON message(sender_id, receiver_id, created_at);
