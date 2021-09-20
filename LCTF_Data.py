from tableauscraper import TableauScraper as TS
import pandas as pd
import os
pwd = os.getcwd()

url = "https://dashboards.doh.nj.gov/views/VaccineCoverageinLTCALfacilitiesPUBLIC/VaccineCoverageinLTCResidentsPUBLIC?:embed=y&:isGuestRedirectFromVizportal=y&:display_count=n&:showAppBanner=false&:origin=viz_share_link&:showVizHome=n"
ts = TS()
ts.loads(url)


worksheet = ts.getWorksheet("Vacc Res Table (2)")
Dashboard = worksheet.data

Dashboard.to_csv(pwd + '\Dashboardori.csv', index = True)


dataset = pd.read_csv(pwd + '\Dashboardori.csv')

print(dataset.head())
dataset.rename(columns = {'Facility Name-value':'Facility Name','Measure Names-alias':'Measure Names','Measure Values-alias':'Measure Values'}, inplace=True)

newark = dataset['Facility Muni-value'] == 'Newark'

datasetmod1 = dataset.loc[newark, ['Facility Name', 'Measure Names', 'Measure Values']]



dataset_modified = datasetmod1.pivot(index = 'Facility Name',
                                columns = 'Measure Names',
                                values = 'Measure Values')



currentdate = pd.Timestamp.now()

currentmonth = currentdate.month
currentday = currentdate.day
currentyear = currentdate.year



now = str(currentmonth) + "/" + str(currentday) +"/" + str(currentyear)

dataset_modified['Date_Updated'] = now
dataset_modified.head()

print(dataset_modified)

dataset_modified.to_csv(pwd + '\LCTF_modified.csv', index = True)
