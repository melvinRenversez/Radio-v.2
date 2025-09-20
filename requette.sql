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

drop table artistes;
drop table albums;
drop table titres;

-- Table artistes
INSERT INTO artistes (nom) VALUES
('Daft Punk'),
('Damien Saez'),
('Coldplay'),
('Adele'),
('Ed Sheeran'),
('Beyoncé'),
('Radiohead'),
('The Weeknd'),
('Taylor Swift'),
('Imagine Dragons');

-- Table albums
INSERT INTO albums (libelle, pochette, annee, fk_artiste) VALUES
('Random Access Memories', 'ram.jpg', 2013, 1),
('Discovery', 'discovery.jpg', 2001, 1),
('Amours Suprêmes', 'amours_suprêmes.jpg', 2012, 2),
('Varsovie 2012', 'varsovie2012.jpg', 2012, 2),
('Parachutes', 'parachutes.jpg', 2000, 3),
('A Rush of Blood to the Head', 'rush_of_blood.jpg', 2002, 3),
('25', '25.jpg', 2015, 4),
('21', '21.jpg', 2011, 4),
('Divide', 'divide.jpg', 2017, 5),
('Multiply', 'multiply.jpg', 2014, 5),
('Lemonade', 'lemonade.jpg', 2016, 6),
('Beyoncé', 'beyonce.jpg', 2013, 6),
('OK Computer', 'ok_computer.jpg', 1997, 7),
('Kid A', 'kid_a.jpg', 2000, 7),
('After Hours', 'after_hours.jpg', 2020, 8),
('Dawn FM', 'dawn_fm.jpg', 2022, 8),
('1989', '1989.jpg', 2014, 9),
('Reputation', 'reputation.jpg', 2017, 9),
('Night Visions', 'night_visions.jpg', 2012, 10),
('Evolve', 'evolve.jpg', 2017, 10);

-- Table titres
INSERT INTO titres (titre, url, fk_album) VALUES
('Get Lucky', 'get_lucky.mp3', 1),
('Instant Crush', 'instant_crush.mp3', 1),
('One More Time', 'one_more_time.mp3', 2),
('Harder, Better, Faster, Stronger', 'hbfs.mp3', 2),
('J\'accuse', 'jaccuse.mp3', 3),
('Petite', 'petite.mp3', 3),
('Les fils d\'Artaud', 'fils_artaud.mp3', 4),
('Helsinki', 'helsinki.mp3', 4),
('Yellow', 'yellow.mp3', 5),
('Shiver', 'shiver.mp3', 5),
('Clocks', 'clocks.mp3', 6),
('The Scientist', 'scientist.mp3', 6),
('Hello', 'hello.mp3', 7),
('When We Were Young', 'when_we_were_young.mp3', 7),
('Rolling in the Deep', 'rolling_deep.mp3', 8),
('Set Fire to the Rain', 'set_fire.mp3', 8),
('Shape of You', 'shape_of_you.mp3', 9),
('Perfect', 'perfect.mp3', 9),
('Photograph', 'photograph.mp3', 10),
('Thinking Out Loud', 'thinking_out_loud.mp3', 10),
('Formation', 'formation.mp3', 11),
('Hold Up', 'hold_up.mp3', 11),
('Drunk in Love', 'drunk_in_love.mp3', 12),
('Flawless', 'flawless.mp3', 12),
('Paranoid Android', 'paranoid_android.mp3', 13),
('Karma Police', 'karma_police.mp3', 13),
('Everything in Its Right Place', 'everything_right.mp3', 14),
('Idioteque', 'idioteque.mp3', 14),
('Blinding Lights', 'blinding_lights.mp3', 15),
('Save Your Tears', 'save_your_tears.mp3', 15),
('Take My Breath', 'take_my_breath.mp3', 16),
('Out of Time', 'out_of_time.mp3', 16),
('Blank Space', 'blank_space.mp3', 17),
('Style', 'style.mp3', 17),
('Look What You Made Me Do', 'look_what.mp3', 18),
('Delicate', 'delicate.mp3', 18),
('Radioactive', 'radioactive.mp3', 19),
('Demons', 'demons.mp3', 19),
('Believer', 'believer.mp3', 20),
('Thunder', 'thunder.mp3', 20),
('Lights', 'lights.mp3', 19),
('I Bet My Life', 'i_bet_my_life.mp3', 20),
('Adventure of a Lifetime', 'adventure_lifetime.mp3', 10),
('Hymn for the Weekend', 'hymn_weekend.mp3', 10),
('Speed of Sound', 'speed_of_sound.mp3', 6),
('Viva La Vida', 'viva_la_vida.mp3', 6),
('Somebody That I Used to Know', 'somebody_used_to_know.mp3', 7),
('Set Fire to the Rain', 'set_fire_rain.mp3', 7),
('Clocks', 'clocks2.mp3', 6),
('Yellow2', 'yellow2.mp3', 5);



select * from titres;
select * from albums;
select * from artistes;

select t.id, t.titre, t.url, al.libelle as album, al.pochette, ar.nom as artiste from titres t
join albums al on al.id = t.fk_album
join artistes ar on ar.id = al.fk_artiste;
