**🏏 IPL Cricket Data Transformation using dbt and MySQL**
This project focuses on transforming IPL (Indian Premier League) cricket match data using dbt (Data Build Tool) and MySQL.
The source data is in the form of ZIP files containing JSON files for each match. A Python script converts this raw data into a CSV format, which is then seeded into a MySQL database.
We use dbt to build a modular data transformation pipeline on top of this dataset, enabling clean, well-documented, and scalable analytics-ready tables.

**📦 Project Overview**
Source: Raw cricket match data in zipped JSON format

Conversion: Python script to convert JSONs to CSV

Storage: MySQL database (ipl_match_data table)

Transformation: dbt models for data processing

Usage: Easily run, debug, and build new transformations with dbt run
