#use reduce() to test out words to the next to the next and to the next until sentences are forumlated. 

#reduce(lambda x,y: x+y,lst) example of reduce function

#!!!!!map() might be useful to iterate through fastest
#list(map(lambda x: (9/5)*x + 32, temps))
# maps(function, dictionary) 
# it can see if test to see if there is statistical relation between two strings
#a = [1,2,3,4]
#b = [5,6,7,8]
#c = [9,10,11,12]

#list(map(lambda x,y:x+y,a,b))
#Out[4]:
#[6, 8, 10, 12]
#In [5]:
# Now all three lists
#list(map(lambda x,y,z:x+y+z,a,b,c))

#key words can be used to find 3 word data sets to finish a sentence 

#Construct a key word list with good and bad connotations. 

#Use request() to extract data of words into matrices. 3 words in sequence data sets. Form the christmas tree for each 3 word datasets. 

#use Yobotblackjack for feelings.

#marchov_chain for possibilities 

#questions and responses. 

#Start with a greeting or a question or a statement.

#When does Yobot feel like talking?

#how does Yobot observe the chat and take in more data?

#Zip()
#d1 = {'a':1,'b':2}
#d2 = {'c':4,'d':5}
#list(zip(d1,d2))
#[('a', 'c'), ('b', 'd')]

#Enumerate() to count number of words in sentences and or stop if you have repeat words like in this example. 

#for count,item in enumerate(lst):
#    if count >= 2:
#       break
#    else:
#        print(item)

#Same words don't show up next to each other in a sentence list[n] == list[n+1 or n-1] = False Make sure that the same words do not show up twice. 


#In the end is the sentence a variation of an existing string pattern? If so then return as true. 

# Using list comprehension
#List = [list_of_words[i:i + 3]
#for i in range(len(list_of_words) - 2)]
# printing list
#print(List)

#list.of_words.append(words with statistical power to create a sentence) will start forming sentences.

#Use a generator and yield to create sentences so you don't take up so much RAM! example below.
#for x in range(n):
	#yield x**3
	
#StringIO scraping strings from web and seeing strings as fils?

#from collections import Counter
#Counter()
#can converto normal dictionary 
#s = [words]
#words = s.split()
#c = Counter(words)
#dict(c) will turn this into a dictonary that will show you the count of each word in that dictionary.

#when getting strings you will probably need to use split() at some point. 

#Ordered dictionaries is the key for creating sentences. 

#!!!!!!Use the deque feature on python to append or remove words from begging or ends to create sentences based on arguements. 
#from collections import deque

#!!!!Regular Expressions Module important (use this to return related key terms or sentences already formed)
#import re
#re.search('hello', 'hello world!)

#import re

# List of patterns to search for
#patterns = ['term1', 'term2']

# Text to parse
#text = 'This is a string with term1, but it does not have the other term.'

#for pattern in patterns:
#   print('Searching for "%s" in:\n "%s"\n' %(pattern,text))
    
    #Check for match
#    if re.search(pattern,text):
#        print('Match was found. \n')
#    else:
#        print('No Match was found.\n')

#use re.findall() to find all instances of a match 

re Pattern Syntax
This will be the bulk of this lecture on using re with Python. Regular expressions support a huge variety of patterns beyond just simply finding where a single string occurred.

We can use metacharacters along with re to find specific types of patterns.

Since we will be testing multiple re syntax forms, let's create a function that will print out results given a list of various regular expressions and a phrase to parse:

In [7]:
def multi_re_find(patterns,phrase):
    '''
    Takes in a list of regex patterns
    Prints a list of all matches
    '''
    for pattern in patterns:
        print('Searching the phrase using the re check: %r' %(pattern))
        print(re.findall(pattern,phrase))
        print('\n')

#! need to create a parsing function to parse the sentence together once you have the significant statistical sentence. 

#import pdb
#pdb.set_trace()
#for debugging. 

#Finally the bot should be able to look up information from the internet by searching for it if it does not have information on it. Like reading.

