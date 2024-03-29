import requests
from bs4 import BeautifulSoup
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os

print(os.getcwd())


# Setup Firebase app
cred = credentials.Certificate(".\\lib\\aditives_import\\food-audit-ab3b3-firebase-adminsdk-sqowh-a2633b8f3c.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://food-audit-ab3b3.firebaseio.com/'
})
firestore_client = firestore.client()
# Scrape the additives and their codes from the website
url = "https://www.ferpotravina.cz/seznam-ecek"
res = requests.get(url)
soup = BeautifulSoup(res.text, 'html.parser')
additives = soup.find_all("td", class_="additives-table__code")
codes = soup.find_all("td", class_="additives-table__name")
scores = soup.find_all("td", class_="additives-table__score")
# Store the additives and their codes in Firebase
doc_ref = firestore_client.collection("aditivs").document("zUmqnGq9nfX5T8M2uupy")
for i in range(len(additives)):
    name = codes[i].text.strip()
    key = additives[i].text.strip()
    # get description here
    descriptionUrl = "https://www.ferpotravina.cz/seznam-ecek/" + key
    res = requests.get(descriptionUrl)
    soup = BeautifulSoup(res.text, 'html.parser')
    description = soup.find("div", class_="additive-detail__content").contents[2].text.strip()
    if '(' in name:
        name, other_names = name.split(' (')
        other_names = other_names.strip().rstrip(')').split(', ')
        other_names.append(name)
    else:
        other_names = [name]

    doc_ref.update({
        key.replace('(', '').replace(')', ''): {
            'names': other_names,
            'score': scores[i].text,
            'description': description
        }
    })
