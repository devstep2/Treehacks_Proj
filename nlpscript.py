#This file contains code for question processing. Reads in a string from inputfp, writes commma-separated values to outputfp

#Import/install modules and load spacy
import sys
import subprocess
try:
    import spacy
except:
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'spacy'])
    subprocess.check_call([sys.executable, '-m', 'spacy', 'download', 'en_core_web_sm'])
try:
    from word2number import w2n
except:
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'word2number'])

nlp = spacy.load("en_core_web_sm")

#Define input and output files
inputfp = 'question.txt'
outputfp = 'objects.txt'

#Define Character class
class Character:
    def __init__(self,name,qty,obj):
        self.name = name
        self.qty = qty
        self.obj = obj
    
    def __str__(self):
        return f"{self.name},{self.qty},{self.obj}"

#Process input file question.txt into spacy
text = "Bob has three apples and then loses two. How many  does he have left?"
#with open(inputfp) as f:
#    text = f.read()
doc = nlp(text)

print("Question statement:")
print(text)

countlocs = [] #stores index locations of each number in the text
characters = [] #stores a uniq list of unique characters (i.e. potential possessors)
initverbs = ["have","possess","own"] #set of verbs that are allowed for the initial problem state

#Create a set of characters, get the locations of numbers in the text
for i in range(len(doc)):

    #update character list
    if(doc[i].pos_ == "PROPN"):
        #check that the doc doesn't already exist
        newchar = True
        for character in characters:
            if(character.name == doc[i].lemma_):
                newchar = False
                break
        if(newchar):
            characters.append(Character(doc[i].lemma_,0,""))

    #update number posn's list
    if(doc[i].pos_ == "NUM"):
        countlocs.append(i)

#Iterate through each number in the text
for numposn in countlocs:
  qty_idx = numposn
  possessor_idx = -1
  obj_idx = -1
  verb_idx = -1

  #Possessor: find the closest proper noun before the number
  possessorfound = False
  for i in reversed(range(numposn)):
    if(doc[i].pos_ == "PROPN"):
      possessor_idx = i
      possessorfound = True
      break

  #Possessor: look after the number if no noun before number
  if(possessorfound == False):
    for j in range(numposn,len(doc)):
      if(doc[j].pos_ == "PROPN"):
        possessor_idx = j
        possessorfound = True
        break
  
  #Object: find the closest noun after the number
  objectfound = False
  for i in range(numposn,len(doc)):
    if(doc[i].pos_ == "NOUN"):
      obj_idx = i
      objectfound = True
      break
    
    #Object: look before the number if no noun after number
    if(objectfound == False):
      for j in reversed(range(numposn)):
        if(doc[j].pos_ == "NOUN"):
          obj_idx = j
          objectfound = True
          break
  
  #Verb: find the closest verb before the number
  for i in reversed(range(numposn)):
    if(doc[i].pos_ == "VERB"):
      verb_idx = i
      break

  """
  #print values
  print("Possessor:",doc[possessor_idx].lemma_)
  print("Object:",doc[obj_idx].lemma_)
  print("Quantity:",w2n.word_to_num(doc[qty_idx].lemma_))
  print("Verb:",doc[verb_idx].lemma_)
  print("Initial state:", "INCLUDE" if doc[verb_idx].lemma_ in initverbs else "EXCLUDE")
  print("")
  """

  #Update characters
  if doc[verb_idx].lemma_ in initverbs:
      for i in range(len(characters)):
          if(characters[i].name == doc[possessor_idx].lemma_):
              characters[i].qty = w2n.word_to_num(doc[qty_idx].lemma_)
              characters[i].obj = doc[obj_idx].lemma_
              break


#Print objects to load in initial state
print("Initial state character frames:")
for character in characters:
    print(character)


#Overwrite output file objects.txt with objects
result = ""
f = open(outputfp,"w")
for character in characters:
    f.write(str(character))
    f.write("\n")
    result += (str(character) + "\n")
f.close()
