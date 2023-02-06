import requests
from bs4 import BeautifulSoup
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase_admin import firestore
import os
import base64

print(os.getcwd())


# Setup Firebase app
cred = credentials.Certificate(".\\google_ml_kit\\example\\lib\\aditives_import\\food-audit-ab3b3-firebase-adminsdk-sqowh-a2633b8f3c.json")
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
    if '(' in name:
        name, other_names = name.split(' (')
        other_names = other_names.strip().rstrip(')').split(', ')
        other_names.append(name)
    else:
        other_names = [name]
    key = additives[i].text.strip().replace('(', '').replace(')', '')

    doc_ref.update({
        key: {
            'names': other_names,
            'score': scores[i].text
        }
    })
