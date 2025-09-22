use testRadio;

	create table titres (
		id int primary key auto_increment,
		titre varchar(255) not null,
		url varchar(255) not null,
		created_at timestamp default current_timestamp,
		fk_album int,
		constraint fk_album foreign key (fk_album) references albums(id)
	);

	create table albums(
		id int primary key auto_increment,
		libelle varchar(255) not null,
		pochette varchar(255),
		annee int,
		fk_artiste int, 
		constraint fk_artiste foreign key(fk_artiste) references artistes(id)
	);

	create table artistes (
		id int primary key auto_increment,
		nom varchar(255) not null
	);


CREATE TABLE historiques (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fk_titre INT NOT NULL,
    played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_titre FOREIGN KEY (fk_titre) REFERENCES titres(id) ON DELETE CASCADE
);

drop table artistes;
drop table albums;
drop table titres;
drop table historiques;


-- 1. Insérer les artistes
INSERT INTO artistes (nom) VALUES
('Mass Hysteria'),
('Rag''n''Bone Man'),
('Rammstein'),
('Renaud'),
('Saez'),
('Still Corners'),
('Scorpions'),
('System Of A Down');

-- 2. Insérer les albums
INSERT INTO albums (libelle, pochette, annee, fk_artiste) VALUES
('Matière Noire', 'matiere_noire.jpg', 2015, 1),       -- Mass Hysteria
('Human', 'human.jpg', 2017, 2),                        -- Rag'n'Bone Man
('Herzeleid', 'herzeleid.jpg', 1995, 3),                -- Rammstein
('Mistral Gagnant', 'mistral_gagnant.jpg', 1985, 4),    -- Renaud
('God Blesse', 'god_blesse.jpg', 2002, 5),              -- Saez
('Strange Pleasures', 'strange_pleasures.jpg', 2013, 6),-- Still Corners
('Love at First Sting', 'love_at_first_sting.jpg', 1984, 7), -- Scorpions
('Toxicity', 'toxicity.jpg', 2001, 8);                  -- System Of A Down

-- 3. Insérer les titres
INSERT INTO titres (titre, url, fk_album) VALUES
-- Mass Hysteria
('Chiens de la casse', 'Mass Hysteria - Chiens de la casse.mp3', 1),
('L''Enfer Des Dieux', 'Mass Hysteria - L''Enfer Des Dieux.mp3', 1),
('Mass veritas', 'Mass Hysteria - Mass veritas.mp3', 1),

-- Rag'n'Bone Man
('Human', 'Rag''n''Bone Man - Human (Official Video) [L3wKzyIN1yk].mp3', 2),

-- Rammstein
('Rammstein', 'Rammstein - Rammstein.mp3', 3),
('Sonne', 'Rammstein - Sonne.mp3', 3),

-- Renaud
('Mistral gagnant', 'Renaud - Mistral gagnant (Clip officiel).mp3', 4),

-- Saez
('Fils de France', 'SAEZ - Fils de france.mp3', 5),

-- Still Corners
('The Trip', 'Still Corners - The Trip.mp3', 6),

-- Scorpions
('Still Loving You', 'Still Loving You.mp3', 7),

-- System Of A Down
('Aerials', 'System Of A Down - Aerials (Official HD Video).mp3', 8),
('Chop Suey', 'System Of A Down - Chop Suey.mp3', 8),
('Lonely Day', 'System Of A Down - Lonely Day (Official HD Video).mp3', 8),
('Sugar', 'System Of A Down - Sugar (Official HD Video).mp3', 8),
('Toxicity', 'System Of A Down - Toxicity (Official HD Video).webm', 8);

-- Mass Hysteria (3 titres)
INSERT INTO historiques (fk_titre, played_at) VALUES
(1, '2025-09-21 18:30:00'), -- Chiens de la casse
(3, '2025-09-21 19:45:00'), -- Mass Veritas

-- Still Corners
(9, '2025-09-22 14:15:00'), -- The Trip

-- Scorpions
(10, '2025-09-22 14:45:00'), -- Still Loving You

-- System Of A Down (5 titres)
(14, '2025-09-22 15:25:00'), -- Sugar
(11, '2025-09-22 15:00:00'), -- Aerials
(12, '2025-09-22 15:10:00'), -- Chop Suey
(13, '2025-09-22 15:15:00'), -- Lonely Day
(15, '2025-09-22 15:35:00'); -- Toxicity



select * from titres;
select * from albums;
select * from artistes;
select * from historiques order by played_at DESC;

SELECT 
    t.id,
    t.titre,
    t.url,
    al.libelle AS album,
    al.annee,
    al.pochette,
    ar.nom AS artiste
FROM titres t
JOIN albums al ON al.id = t.fk_album
JOIN artistes ar ON ar.id = al.fk_artiste
WHERE t.id NOT IN (
    SELECT fk_titre 
    FROM (
        SELECT fk_titre 
        FROM historiques 
        ORDER BY played_at DESC 
        LIMIT 10
    ) AS h_recent
)
ORDER BY t.titre ASC;


INSERT INTO historiques (fk_titre, played_at) VALUES
(1, '2025-09-23 10:30:00');


select fk_titre from historiques limit 10;


SELECT 
    h.id AS historique_id,
    t.titre,
    a.nom AS artiste,
    h.played_at
FROM historiques h
JOIN titres t ON h.fk_titre = t.id
JOIN albums al ON t.fk_album = al.id
JOIN artistes a ON al.fk_artiste = a.id
ORDER BY h.played_at DESC;
