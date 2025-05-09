**Running the dbt Project**
Follow the steps below to set up and run this dbt project:

**Set Up a Virtual Environment**
Create and activate a virtual environment:

python -m venv venv
venv\Scripts\activate

**Install Required Packages**
Install the necessary Python packages:

pip install dbt-mysql pandas


**Convert Cricket Data (ZIP to CSV)**
Run the following script to convert the cricket match data from ZIP files to CSV format:

python ipl_json_to_csv_conversion.py


**Seed the Data into MySQL**
Load the generated CSV file into your MySQL database with the table name ipl_match_data.

add csv file in seeds folder with name "ipl_match_data"
run **dbt seed** 

**Run the dbt Models**
To run all dbt models:

**dbt run**

To run a specific model or macro:

**dbt run --select <model_or_macro_name>**
