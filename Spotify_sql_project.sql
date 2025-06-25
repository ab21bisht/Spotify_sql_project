DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


select *
from spotify;

#1.Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify
where stream >1000000000;

#2.List all albums along with their respective artists.
select distinct album, artist 
from spotify;

#3.Get the total number of comments for tracks where licensed = TRUE.
select track,sum(comments) as total_comments
from spotify
where licensed = TRUE
group by 1
order by 2 desc;

#4.Find all tracks that belong to the album type single.
select track,album_type
from spotify
where album_type = 'single';

#5.Count the total number of tracks by each artist.
select artist, count(track)
from spotify
group by 1
order by 2 desc;

#6.Calculate the average danceability of tracks in each album.
select album, avg(danceability)
from spotify
group by 1
order by 2 desc;

#7.Find the top 5 tracks with the highest energy values.
select track,energy
from spotify
order by 2 desc
limit 5;

#8.List all tracks along with their views and likes where official_video = TRUE.
select track,sum(views) as views,sum(likes) as likes
from spotify
where official_video = 'true'
group by 1
;

#9.For each album, calculate the total views of all associated tracks.
select 
album,
track,
sum(views) as total_views
from spotify
group by 1,2
order by 3 desc;

#10.Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from
(
	select track,
	coalesce(sum(Case when most_played_on = 'Youtube' then stream end),0) as stream_on_youtube,
	coalesce(sum(Case when most_played_on = 'Spotify' then stream end),0) as stream_on_spotify
	from spotify 
	group by 1
) as t1
where 
stream_on_spotify > stream_on_youtube
and
stream_on_youtube <>0;

#11.Find the top 3 most-viewed tracks for each artist using window functions.
with ranking_artist as 
(
	select artist,track,
	sum(views) as total_view,
	dense_rank() over(partition by artist order by sum(views) desc) as rank
	from spotify
	group by 1,2
	order by 1,3 desc
)
select * from ranking_artist
where rank <=3;


#12.Write a query to find tracks where the liveness score is above the average.
select track,artist,liveness
from spotify
where liveness > (select avg(liveness) from spotify);

#13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with energy_ as 
(
select 
	album,
	max(energy) as highest_energy,
	min(energy) as lowest_energy
from spotify
group by 1
)
select album,
highest_energy,
	lowest_energy,
	highest_energy - lowest_energy as difference
from energy_
order by 4 desc;