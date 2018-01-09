#! /usr/bin/python3

from imdb import IMDb
import json
ia = IMDb()
data = " "
i = 0
with open('/home/ubuntu/workspace/a') as fp:
  line = fp.readline()
  while line:
    print(i)
    tt = line[2:]
    print(tt)
    movie = ia.get_movie(tt)
    i = i + 1
    if movie.has_key('plot outline'):
      data = data + str(movie['plot outline']) + "\n"
    else:
      print("Oh no")

    if i%10 == 0:
      with open('result1', 'w') as outfile:
        outfile.write_to_csv(data)
    line = fp.readline()
#json_data = json.dumps(data)

with open('result1', 'w') as outfile:
  outfile.write_to_csv(data)
