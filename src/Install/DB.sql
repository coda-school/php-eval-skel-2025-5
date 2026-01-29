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
followed_id BIGINT NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (follower_id, followed_id),
FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
FOREIGN KEY (followed_id) REFERENCES users(id) ON DELETE CASCADE
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
