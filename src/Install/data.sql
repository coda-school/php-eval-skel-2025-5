CREATE TABLE IF NOT EXISTS tweet (
                                     id SERIAL PRIMARY KEY,
                                     user_id INT NOT NULL,
                                     content VARCHAR(280) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE
    );


TRUNCATE "user", tweet RESTART IDENTITY CASCADE;


INSERT INTO "user" (id, username, email, password, roles, bio, created_at, is_verified) VALUES
                                                                                            (1, 'alice', 'alice@mail.com', 'hash1', '["ROLE_USER"]', 'Bio de Alice', NOW(), true),
                                                                                            (2, 'bob', 'bob@mail.com', 'hash2', '["ROLE_USER"]', 'Bio de Bob', NOW(), true),
                                                                                            (3, 'charlie', 'charlie@mail.com', 'hash3', '["ROLE_USER"]', 'Bio de Charlie', NOW(), true),
                                                                                            (4, 'david', 'david@mail.com', 'hash4', '["ROLE_USER"]', 'Bio de David', NOW(), true),
                                                                                            (5, 'emma', 'emma@mail.com', 'hash5', '["ROLE_USER"]', 'Bio de Emma', NOW(), true);


INSERT INTO tweet (user_id, content, created_at) VALUES
                                                     (1, 'Bonjour Twitter alternatif 👋', NOW()),
                                                     (1, 'Le café avant le code ☕', NOW()),
                                                     (2, 'Hello world.', NOW()),
                                                     (3, 'Mais ça compile 😎', NOW()),
                                                     (5, 'UX > tout', NOW());
