# Analysis of Movielens Using PostgreSQL


This repository contains an analysis of the Movielens dataset using PostgreSQL. The analysis aims to gain insights into movie ratings, user behavior, and other relevant information to better understand the preferences of users.

## Introduction

Movielens is a popular dataset that contains movie ratings and other metadata. The analysis in this repository leverages the power of PostgreSQL, a powerful relational database, to perform queries and derive meaningful conclusions from the data.

## Data

The dataset consists of the following data files:

- `movies.csv`: Contains movie information, such as movie ID, title, genre and year.
- `tags.csv`: Contains movie tags, including user ID, movie ID, and timestamp.
- `ratings.csv`: Contains movie ratings given by users, including user ID, movie ID, rating, and timestamp.
- `links.csv`: Contains information, such as movie ID, IMDbID ad TMDbID.

## Files

- `Movielens.sql`: SQL script containing the queries used to perform the analysis on the Movielens dataset.

## Usage

To perform the analysis using PostgreSQL:

1. Download the Movielens dataset and place the CSV files (`movies.csv`, `ratings.csv`,`links.csv`, and `tags.csv`) in a directory accessible by your PostgreSQL instance.

2. Connect to your PostgreSQL database using a client of your choice.

3. Execute the SQL queries in `Movielens.sql` in the PostgreSQL database to perform the analysis.

## Analysis Insights

The SQL queries in `Movielens.sql` cover various aspects of the Movielens dataset. Some of the insights derived from the analysis include:

- Popular movies based on the number of ratings and average ratings.
- Top-rated genres and their respective ratings.
- Distribution of user ratings and average rating per user.
- Users with the most ratings and their preferences.

## Contribution

Contributions to this project are welcome. If you have ideas for additional analyses, improvements to existing queries, or new visualizations, feel free to open a pull request.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the SQL queries and analysis results as per the terms of the license.


I hope you find the analysis of Movielens using PostgreSQL interesting and insightful! Thank you for visiting the repository.
