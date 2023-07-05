import pandas as pd

#Reading the excel workbook, the master accounts list and the journal entries
journal_entries_df = pd.read_excel('PythonAcctTest.xlsx', sheet_name='JournalEntries')
master_accounts_df = pd.read_excel('PythonAcctTest.xlsx', sheet_name='AccountMasterList')

#Create a dictionary to hold data frames for each account
accounts_dfs = {}

#On the output, create a new sheet and data frame for each account
for accounts in master_accounts_df['Accounts']:
    accounts_df = journal_entries_df[journal_entries_df['AcctName'] == accounts]
    accounts_dfs[accounts] = accounts_df

#Create a dataframe for the unassigned entries
unassigned_df = journal_entries_df[~journal_entries_df['AcctName'].isin(master_accounts_df['Accounts'])]

#Add the unassigned_df to the df dictionary with the key 'Unassigned'
accounts_dfs['Unassigned'] = unassigned_df

#Create the output file, using a with statement
with pd.ExcelWriter('output_accounts.xlsx') as writer:
    for accounts, accounts_df in accounts_dfs.items():
        accounts_df.to_excel(writer, sheet_name=str(accounts), index=False)

# Converting Date column to a string formatted as 'YYYY-MM-DD'
journal_entries_df['Date'] = pd.to_datetime(journal_entries_df['Date']).dt.date.astype(str)

# Creating multiple data frames, each representing a month
dfs_by_month = {month: journal_entries_df[journal_entries_df['Date'].str[5:7] == f'{month:02d}'] for month in range(1, 13)}

#Using a with statement, creates output.xslx
with pd.ExcelWriter('output_month.xlsx') as writer:
    for month, df_month in dfs_by_month.items():
        df_month.to_excel(writer, sheet_name=f'Month {month}', index=False)
