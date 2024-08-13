# CONNECT TO MYSQL SCHEMA
# import mysql connector
import mysql.connector

# establish connection to schema
treasure_hunt_db = mysql.connector.connect(
    host='localhost',
    user='root',
    password='password',
    port='3306',
    database='treasure_hunt_app'
)

# establish cursor
cursor = treasure_hunt_db.cursor()


def get_table(table_name, display=False):
    cursor.execute(f'SELECT * FROM {table_name}')
    table = cursor.fetchall()
    if display is True:
        print(f"TABLE: {table_name}")
        for row in table:
            print(row)
    print()


get_table("users", True)

get_table("creator")
get_table("team")
get_table("hunter")
get_table("members")
get_table("treasure_hunt")
get_table("hunts_in")
get_table("treasure")


print()


# QUERIES
def query(query):
    cursor.execute(query)
    result = cursor.fetchall()
    for tup in result:
        print(tup)


print("QUERY 1 - View the users and the team ID they belong to")
query1 = 'SELECT u.ID, m.team_ID FROM users AS u INNER JOIN members AS m ON (u.ID = m.H_ID)'
query(query1)


print("Query 2 - Retrieve the users, the team they participate in, and the number of members on that team")
query2 = 'SELECT u.ID, m.team_ID, t.size FROM team t ' \
         'JOIN members m ON (t.team_ID = m.team_ID) JOIN users u ON (m.H_ID = u.ID)'
query(query2)


print("Query 3 - Which users have won more than 2 times")
query3 = 'SELECT ID, num_wins FROM users WHERE num_wins > 2'
query(query3)


print("Query 4 - Which users are in team 2?")
query4 = 'SELECT ID FROM users WHERE ID IN (SELECT H_ID FROM members WHERE team_ID=102)'
query(query4)


# PLOTS
print("PLOTS")
print()
import pandas as pd
import matplotlib.pyplot as plt

# create dataframe of users table
users = pd.DataFrame(users, columns=["ID", "SSN", "first_name", "last_name", "email", "age", "address", "num_wins",
                                     "winnings"])

# PLOT 1 - num_wins VS total winnings
x = users.loc[:, "num_wins"]
y = users.loc[:, "winnings"]
plt.scatter(x, y)
plt.title("num_wins VS winnings")
plt.xlabel("num_wins")
plt.ylabel("winnings")
plt.savefig("plot1")
plt.clf()

# PLOT 2 - bar plot of each user's winnings
x = list(users.loc[:, "ID"])
x = [str(id) for id in x]
y = list(users.loc[:, "winnings"])
plt.bar(x=x, height=y, width=0.8)
plt.title("user winnings")
plt.xlabel("user ID")
plt.ylabel("winnings")
plt.savefig("plot2")
plt.clf()

# PLOT 3 - percentage of treasures prize_values
#create dataframe of treasure
treasure = pd.DataFrame(treasure, columns=["hunt_ID", "prize_value", "latitude", "longitude"])
prize_values = treasure.loc[:, "prize_value"]
print(treasure)
print(prize_values)
def count(list1, l, r):
    return len(list(filter(lambda val: l <= val <= r, list1)))

zero_to_fifty = count(prize_values, 0, 50)
fifty_to_hundred = count(prize_values, 50, 100)
over_hundred = count(prize_values, 100, 1000)

sizes = [zero_to_fifty, fifty_to_hundred, over_hundred]
labels = "below 50", "between 50 and 100", "over 100"
fig, ax = plt.subplots()
print(sizes)
ax.pie(sizes, labels=labels, autopct='%1.1f%%')
plt.title("Treasure prize values")
plt.savefig("plot3")
