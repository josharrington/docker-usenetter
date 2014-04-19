#! /usr/bin/env python

import pickle
import uuid
import feedparser 
import sys
import urllib

PICKLE_FILE = "finished.pickle"
WATCH_DIR = "/root/watch/"
RSSFEED = sys.argv[1]

if __name__ == "__main__":
	feed = feedparser.parse(RSSFEED)
	urls = [i["link"] for i in feed["items"]]

	try:
		done = pickle.load(open(PICKLE_FILE,'rb'))
	except:
		done = []


	for url in urls:
		if url not in done:
			filename = str(uuid.uuid4()) + ".torrent"	
			urllib.urlretrieve(url, WATCH_DIR + filename)
			done.append(url)

	pickle.dump(done, open(PICKLE_FILE,'wb'))



