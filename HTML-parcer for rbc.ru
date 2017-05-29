#importing everything we need
from firebase import firebase
import requests
from bs4 import BeautifulSoup

class Article:
    title = ''
    text = ''
    author = ''
    time = ''
    image = ''

    def __init__(self, title, text, author, time, image):
        self.title = title
        self.text = text
        self.author = author
        self.time = time
        self.image = image

#preparing for parsing
urls = ["http://www.rbc.ru/politics/29/05/2017/592bd8f89a7947b6996ecfa7?from=newsfeed", "http://www.rbc.ru/rbcfreenews/592bd5509a7947b57297c898?from=newsfeed", "http://www.rbc.ru/rbcfreenews/592bd5639a7947b4a86b1fe0?from=newsfeed", "http://www.rbc.ru/rbcfreenews/592bd7939a7947b68d1ffbc4?from=newsfeed", "http://www.rbc.ru/rbcfreenews/592bc9ca9a7947b12f6cfafa?from=newsfeed", "http://www.rbc.ru/rbcfreenews/592bd4439a7947b55a2e301e?from=newsfeed", "http://www.rbc.ru/politics/29/05/2017/592bce979a7947b2f052fc4c?from=newsfeed", "http://www.rbc.ru/finances/29/05/2017/592bb4a69a7947a8267dbbf7?from=newsfeed", "http://www.rbc.ru/rbcfreenews/592b8db99a79479cbef90aef?from=newsfeed", "http://www.rbc.ru/rbcfreenews/592b5f509a7947921d7c92e5?from=newsfeed"]
firebase_url = "https://exam-76a95.firebaseio.com/"
articles = []

for i in range(0, len(urls)):
    html_doc = requests.get(urls[i]).text
    soup = BeautifulSoup(html_doc, "lxml")
    info = soup.find("body", {"class": "news"})

    try:
        author = info.find("div", {"class" : "article__header__author-block"}).text
    except AttributeError:
        author = "no author"

    try:
        title = info.find("span", {"class" : "header__article-category__title"}).text
    except AttributeError:
        title = "no title"

    try:
        text = info.find("div", {"class" : "article__content"}).text
    except AttributeError:
        text = "no text"

    try:
        time = info.find("span", {"class" : "article__header__date"}).text
    except AttributeError:
        time = "no time"

    try:
        image = info.find("a", {"class" : "highslide js-infocraphics article__main-image__link"}).find("img")["src"].text
    except AttributeError:
        image = "no image"

    articles.append(Article(title, text, author, time, image))
print(info)
db = firebase.FirebaseApplication(firebase_url)

for smth in articles:
    print(smth.__dict__)
    db.post("/articles", smth.__dict__)
