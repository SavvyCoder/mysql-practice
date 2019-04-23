"Why does my cat look at me with such hatred"

SELECT REVERSE("Why does my cat look at me with such hatred");
SELECT UPPER("Why does my cat look at me with such hatred");

SELECT UPPER (
    CONCAT(
        author_fname,
        ' ',
        author_lname
    )
) AS 'full name in caps' FROM books; 

SELECT CONCAT (
    title,
    ' was released in ',
    released_year
) AS blurb FROM books; 

SELECT title, CHAR_LENGTH(title) AS 'character count' FROM books; 

SELECT 
CONCAT(SUBSTRING(
        title, 
        1,
        10
    ),
    "..."
) AS 'short title',
CONCAT(
    author_lname,
    ',',
    author_fname
) AS author,
CONCAT(
    stock_quantity,
    " in stock"
) AS quantity 
FROM books;

EXERCISE 8

SELECT title FROM books WHERE title LIKE '%stories%';
SELECT title, pages FROM books ORDER BY pages DESC LIMIT 1; 

SELECT CONCAT(
    title,
    ' - ',
    released_year
) AS summary FROM books ORDER BY released_year DESC LIMIT 3; 

SELECT title, author_lname FROM books WHERE author_lname LIKE '% %';
SELECT title, released_year, stock_quantity FROM books ORDER BY 3 LIMIT 3;
SELECT title, author_lname FROM books ORDER BY 2,1;
SELECT CONCAT(
    'MY FAVORITE AUTHOR IS ',
    UPPER(author_fname),
    ' ',
    UPPER(author_lname),
    '!'
) AS yell FROM books ORDER BY author_lname; 

SELECT CONCAT (
    author_fname,
    " ",
    author_lname
) AS 'Author',
SUM(pages) AS 'Page Sum' FROM books GROUP BY author_lname, author_fname;

SELECT COUNT(*) AS 'Number of Books' FROM books;

SELECT released_year, COUNT(*) AS 'Number of Books Released' FROM books GROUP BY released_year;

SELECT SUM(stock_quantity) FROM books; 

SELECT author_fname, author_lname, AVG(released_year) FROM books GROUP BY author_lname, author_fname;

SELECT CONCAT(
    author_fname,
    " ",
    author_lname
) AS "Author", pages FROM books ORDER BY pages DESC LIMIT 1;

SELECT * FROM books;     

SELECT released_year AS 'year', COUNT(*) AS '# books', AVG(pages) AS 'avg pages' FROM books GROUP BY released_year ORDER BY released_year; 

SELECT CONCAT(
    author_fname,
    " ",
    author_lname
) AS Author FROM books WHERE pages=(SELECT MAX(pages) FROM books);

 EXERCISE 10

CREATE TABLE tweet_table(
    content VARCHAR(140) NOT NULL,
    username VARCHAR(25) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
)

INSERT INTO tweet_table(content, username) VALUES('This my first tweet OMG SMASH THAT RT & <3', 'BANono?');

SELECT * FROM tweet_table; 

EXERCISE 11

SELECT * FROM books WHERE released_year < 1980; 

SELECT * FROM books WHERE author_lname IN('Eggers', 'Chabon');

SELECT * FROM books WHERE author_lname = 'Lahiri' &&
                          released_year > 2000
                    ORDER BY released_year;

SELECT * FROM books WHERE pages BETWEEN 100 AND 200 ORDER BY pages; 
SELECT * FROM books WHERE author_lname LIKE 'S%' || author_lname LIKE 'C%';
SELECT title,
      author_lname, 
      CASE
        WHEN title LIKE '%stories%' THEN 'Short Stories'
        WHEN title IN('Just Kids','A Heartbreaking Work of Staggering Genius') THEN 'Memoir'
        ELSE 'Novel'
        END AS 'TYPE'
        FROM books; 
SELECT title, 
      author_lname, 
      CONCAT(
        COUNT(*),
        CASE
            WHEN COUNT(*) > 1 THEN ' books'
            ELSE ' book'
        END 
      ) AS 'COUNT'
      FROM books GROUP BY author_lname, author_fname; 

EXERCISE 12

CREATE TABLE students(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    first_name VARCHAR(25)
);

CREATE TABLE papers(
    title VARCHAR(100),
    grade INT,
    student_id INT,
    FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE
);

INSERT INTO students (first_name) VALUES 
('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers (student_id, title, grade ) VALUES
(1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);

SELECT first_name, 
      title, 
      grade 
      FROM students
      JOIN papers
      ON students.id = papers.student_id ORDER BY grade DESC; 

SELECT first_name, 
      IFNULL(title, 'MISSING'),
      IFNULL(grade, 0) 
      FROM students
      LEFT JOIN papers
      ON students.id = papers.student_id; 

SELECT first_name, 
      IFNULL(AVG(grade), 0) AS average,
      CASE WHEN IFNULL(AVG(grade), 0) >= 75 THEN 'PASSING' ELSE 'FAILING' END AS passing_status
      FROM students
      LEFT JOIN papers
      ON students.id = papers.student_id GROUP BY id ORDER BY average DESC; 


EXERCISE 13

CREATE TABLE reviewers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

CREATE TABLE series(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    released_year YEAR(4),
    genre VARCHAR(100)
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rating DECIMAL(2,1),
    series_id INT,
    reviewer_id INT,
    FOREIGN KEY(series_id) REFERENCES series(id),
    FOREIGN KEY(reviewer_id) REFERENCES reviewers(id)
);

JOIN SERIES TABLE AND REVIEW TABLE 

SELECT title, rating FROM series 
JOIN reviews
ON series.id = reviews.series_id; 

SELECT title, 
      AVG(rating) AS avg_rating 
FROM series 
JOIN reviews
      ON series.id = reviews.series_id 
GROUP BY series.title 
ORDER BY avg_rating; 

SELECT first_name,
      last_name,
      rating
FROM reviewers
JOIN reviews
     ON reviewers.id = reviews.reviewer_id;

SELECT title AS unreviewed_series
FROM series 
LEFT JOIN reviews
     ON series.id = reviews.series_id
WHERE rating IS NULL;

SELECT genre,
      AVG(rating) AS avg_rating
FROM series
JOIN reviews
ON series.id = reviews.series_id
GROUP BY genre;

SELECT first_name,
      last_name,
      COUNT(rating)
      AS 'COUNT',
      IFNULL(MIN(rating),0) AS 'MIN',
      IFNULL(MAX(rating),0) AS 'MAX',
      IFNULL(ROUND(AVG(rating),2),0) AS 'AVG',
      CASE
        WHEN IFNULL(MAX(rating),0) = 0
            THEN 'INACTIVE'
        ELSE 'ACTIVE'
      END AS 'STATUS'
FROM reviewers
LEFT JOIN reviews
    ON reviewers.id = reviews.reviewer_id
GROUP BY reviewers.id
ORDER BY 'MIN' DESC;

SELECT title,
      rating,
      CONCAT(
        first_name,
        " ",
        last_name
      ) AS reviewer
FROM reviews
INNER JOIN series
    ON reviews.series_id = series.id
INNER JOIN reviewers
    ON reviews.reviewer_id = reviewers.id;
