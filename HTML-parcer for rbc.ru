#importing everything we need
from firebase import firebase
import requests
from bs4 import BeautifulSoup

class Article:
    title = ''
    text = ''
    author = ''

    def __init__(self, title, text, author):
        self.title = title
        self.text = text
        self.author = author


#preparing for parsing
urls = ["http://www.rbc.ru/finances/29/05/2017/592bc2dd9a7947ad72e25e53?from=newsfeed"]
firebase_url = "https://exam-76a95.firebaseio.com/"
articles = []

for i in range(0, len(urls)):
    html_doc = requests.get(urls[i]).text
    soup = BeautifulSoup(html_doc, "lxml")
    info = soup.find("body", {"class": "news"})
    author = info.find("div", {"class" : "article__header__author-block"}).text
    title = info.find("span", {"class" : "header__article-category__title"}).text
    text = info.find("div", {"class" : "article__content"}).text
    articles.append(Article(title, text, author))

db = firebase.FirebaseApplication(firebase_url)

for smth in articles:
    print(smth.__dict__)
    db.post("/users", smth.__dict__)
