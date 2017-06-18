import webapp2
import os
import logging
import wsgiref.handlers

from google.appengine.ext.webapp import template
from util.sessions import Session
from google.appengine.ext import db
import datetime
import time
from datetime import date

# A Model for a User
class User(db.Model):
  name = db.StringProperty()
  surname = db.StringProperty()
  account = db.StringProperty()
  password = db.StringProperty()
  address= db.PostalAddressProperty()
  cellphone= db.PhoneNumberProperty()
  email= db.EmailProperty()  
  id_photo=db.BlobProperty()

# A Model for a Sender
class Sender(db.Model):
  user=db.ReferenceProperty(User, collection_name= 'current_sender')
  from_=db.StringProperty()
  destination= db.StringProperty()
  urgent = db.BooleanProperty()
  from_date=db.DateTimeProperty()
  until_date = db.DateTimeProperty()
  max_weight = db.FloatProperty()
  max_dimension= db.FloatProperty()

# A Model for a Matching
class Matching(db.Model):
  sender=db.ReferenceProperty(User, collection_name= 'sender')
  transporter=db.ReferenceProperty(User, collection_name= 'transporter')
  sender_details=db.ReferenceProperty(Sender, collection_name='sender_details')

# A Model for a Transporter
class Transporter(db.Model):
  user=db.ReferenceProperty(User, collection_name= 'current_transporter')
  from_=db.StringProperty()
  destination= db.StringProperty()
  arrival_date=db.DateTimeProperty()
  arrival_time=db.DateTimeProperty()
  max_weight = db.FloatProperty()
  max_dimension= db.FloatProperty()
  transport_means = db.StringProperty()


# A helper to do the rendering 
def doRender(handler, tname = 'login.html', values = { }):
  temp = os.path.join(
      os.path.dirname(__file__),
      'templates/' + tname)
  if not os.path.isfile(temp):
    return False

  # Make a copy of the dictionary and add the path and session
  newval = dict(values)
  newval['path'] = handler.request.path
  handler.session = Session()
  if 'username' in handler.session:
     newval['username'] = handler.session['username']

  outstr = template.render(temp, newval)
  handler.response.out.write(unicode(outstr))
  return True

# Login Handler
class LoginHandler(webapp2.RequestHandler):

  def get(self):
    doRender(self, 'login.html')
    
  def post(self):
    self.session = Session()
    acct = self.request.get('account')
    pw = self.request.get('password')
    logging.info('Checking account='+acct+' pw='+pw)

    # Make sure no other user is login
    self.session.delete_item('username')
    self.session.delete_item('userkey')    
    
    # Still no sender or transporter
    self.session['senderflag'] = False
    self.session['transporterflag'] = False
    
    # Check if there is a registered user
    que = db.Query(User)
    que = que.filter('account =',acct)
    que = que.filter('password = ',pw)    
    
    results = que.fetch(limit=1)
    
    # If you found a user logged him in or prompt him to fill in the correct details
    if len(results) > 0 :
      user = results[0]
      self.session['userkey'] = user.key()
      self.session['username'] = acct
      doRender(self,'StartPage.html',{ } )

    else:
      doRender(self,'login.html', {'error' : 'Please fill in the correct details!'})

# SignUp Handler
class ApplyHandler(webapp2.RequestHandler):

  def get(self):
    doRender(self, 'signUp.html')

  def post(self):
    self.session = Session()
    name = self.request.get('user_name')
    surname= self.request.get('user_surname')
    acct = self.request.get('user_username')
    pw = self.request.get('user_password')
    email= self.request.get('user_email')
    cellphone=self.request.get('user_cellphone')
    address= self.request.get('user_address')
    id_photo= self.request.POST.get("ID_photo", None )
    	
    logging.info('Adding account='+acct)

    # Check if the user already exists
    que = db.Query(User).filter('account =',acct)
    results = que.fetch(limit=1)

    if len(results) > 0 :
      doRender(
          self,
          'signUp.html',
          {'error' : 'Please choose a different username! Account Already Exists!'} )
      return

    # Create the User object and save his details
    newuser = User(name=name, surname=surname, account=acct, password=pw, address=address, email=email, cellphone=cellphone, id_photo=str(id_photo));
    pkey = newuser.put();
    self.session['username'] = acct
    self.session['userkey'] = pkey
    doRender(self,'login.html',{ })

class MainPageHandler(webapp2.RequestHandler):

  def get(self):
   self.session=Session() 
   senderflag= self.session['senderflag']
   
   transporterflag= self.session['transporterflag']
   
   if transporterflag: 
      doRender(self, 'MainPage.html', {'transporterflag' : transporterflag})
      return

   
   if not 'sender_key' in self.session:
      doRender(self, 'senderSignIn.html', {'msg' : 'Fill in the details to search for transporters' })
      return

   if senderflag:
     sender_key=self.session['sender_key']
     logging.info('i am in with'+str(self.session['sender_key'] ))
     sender=db.get(sender_key)

     que= db.Query(Transporter).order('arrival_date')
     que= que.filter('from_ = ', sender.from_)
     que= que.filter('destination = ', sender.destination)
     que= que.filter('arrival_date <= ', sender.until_date)
     que= que.filter('arrival_date >= ', sender.from_date)
     que=que.fetch(limit=10)

     if len(que) > 0:
      doRender(self, 'MainPage.html', {'que' : que , 'senderflag' : senderflag})
      return   
     else: 
      doRender(self, 'MainPage.html', {'error' : 'Sorry no transporters available!'})
      return  
      
   doRender(self, 'MainPage.html')

  def post(self):	
   self.session=Session() 
   senderflag= self.session['senderflag']
   
   if senderflag:
     matchingkey =  self.session['matchingkey']
     matching=db.get(matchingkey)
     matching.delete()
     self.get()
  

class ChangeDetailsHandler(webapp2.RequestHandler):

  def get(self):
    self.session = Session()
    userkey=self.session['userkey']
    user=db.get(userkey)

    doRender(self, 'changeDetails.html', {'name' : user.name, 'surname' : user.surname})

  def post(self):
    self.session = Session()
    #name = self.request.get('user_name')
    #surname= self.request.get('user_surname')
    acct = self.request.get('user_username')
    pw = self.request.get('user_password')
    email= self.request.get('user_email')
    cellphone=self.request.get('user_cellphone')
    address= self.request.get('user_address')
   	
    logging.info('Changing account='+acct)

    # Check if the user already exists
    que = db.Query(User).filter('account =',acct)
    results = que.fetch(limit=1)

    if len(results) > 0 :
      doRender(
          self,
          'changeDetails.html',
          {'error' : 'ERROR! Account Already Exists'} )
      return

    ch_userkey=self.session['userkey']
    ch_user=db.get(ch_userkey)
    ch_user.account=acct
    ch_user.password=pw
    ch_user.address=address 
    ch_user.email=email
    ch_user.cellphone=cellphone
    ch_user.put()

    self.session['username'] = acct

    doRender(self,'changeDetails.html',{ 'msg': 'Your details have been changed successfully' })	

class SenderHandler(webapp2.RequestHandler):

  def get(self):
    self.session = Session()
    self.session['senderflag'] = True
    self.session['transporterflag'] = False
    doRender(self, 'senderSignIn.html')
  
  def post(self):
    self.session = Session()
    acct = self.session['username']
    userkey=self.session['userkey']

    sender_from = self.request.get('sender_from')
    sender_to= self.request.get('sender_to')
    sender_from_date = datetime.datetime.strptime(self.request.get('sender_from_date'), "%Y-%m-%d") #convert html date to datetime 
    sender_until_date = datetime.datetime.strptime(self.request.get('sender_until_date'), "%Y-%m-%d") #convert html date to datetime 
    urgent = self.request.get('urgent')
    sender_weight = self.request.get('sender_weight')
    sender_volume = self.request.get('sender_volume')
       
    if urgent == 'yes' :         
      isurgent = True
    else:
      isurgent = False
   
    y=date.today()

    if sender_from_date.date() < y or sender_until_date.date() <y :
       doRender(self,'senderSignIn.html',{'error' : 'Can not insert a date before current date' , 'msg' : 'Please insert the correct details!'  })
       return
      
    if sender_until_date < sender_from_date :
       doRender(self,'senderSignIn.html',{'error' : 'Until date can not be before From Date' , 'msg' : 'Please insert the correct details!' }) 
       return

    
    newsender=Sender(user=userkey, from_=sender_from, destination=sender_to, urgent=isurgent, from_date=sender_from_date, until_date=sender_until_date, max_weight= float(sender_weight), max_dimension=float(sender_volume))
    sender_key=newsender.put()
    self.session['sender_key'] = sender_key 
    self.session['senderflag'] = True 
    self.session['transporterflag'] = False
    logging.info('sender_key='+str(self.session['sender_key'])+str(self.session['senderflag']))
       
    doRender(self,'senderSignIn.html',{ 'msg' : 'Your details saved successfully!' })		
      

class transporterHandler(webapp2.RequestHandler):

  def get(self):
    self.session = Session()
    self.session['transporterflag'] = True
    self.session['senderflag'] = False
    doRender(self, 'transporterSignIn.html') 
  
  def post(self):
    self.session = Session()
    acct = self.session['username']
    userkey=self.session['userkey']

    transporter_from = self.request.get('transporter_from')
    transporter_to= self.request.get('transporter_to')
    transporter_date = datetime.datetime.strptime(self.request.get('transporter_date'), "%Y-%m-%d") #convert html date to datetime 
    transporter_time = datetime.datetime.strptime(self.request.get('transporter_time'), "%H:%M") #convert html date to datetime 
    transporter_weight = self.request.get('transporter_weight')
    transporter_volume = self.request.get('transporter_volume')
    transporter_means = self.request.get('transporter_means')
    
    y=date.today()

    if transporter_date.date() < y :
       doRender(self,'transporterSignIn.html',{'error' : 'Can not insert a date before today', 'msg' : 'Please insert the correct details!' })
       return
    
    newtransporter=Transporter(user=userkey, from_=transporter_from.upper(), destination=transporter_to.upper(), arrival_date=transporter_date,  arrival_time=transporter_time, max_weight= float(transporter_weight), max_dimension=float(transporter_volume), transport_means = transporter_means)
    transporter_key=newtransporter.put()   
    self.session['transporter_key'] = transporter_key
    self.session['transporterflag'] = True
    self.session['senderflag'] = False
    logging.info('Transporter account='+acct)
       
    doRender(self,'transporterSignIn.html',{'msg' : 'Your details saved successfully!'})	
	
class LogoutHandler(webapp2.RequestHandler):

  def get(self):
    self.session = Session()
    self.session.delete_item('username')
    self.session.delete_item('userkey')
    self.session.delete_item('sender_key')
    self.session.delete_item('transporter_key')
    self.session.delete_item('senderflag')
    self.session.delete_item('transporterflag')
    self.session.delete_item('matchingkey')
    doRender(self, 'login.html')


class MatchingHandler(webapp2.RequestHandler):


  def post(self):
   self.session=Session() 
   senderflag= self.session['senderflag']
   transporterflag = self.session['transporterflag']
   userkey=self.session['userkey']
   username=self.session['username']
   
   if senderflag:
     matchingacct = self.request.POST.get('match_name', "")
     logging.info('i am in with'+matchingacct)
     
     que = db.Query(User)
     que = que.filter('account =',matchingacct)
   
     results = que.fetch(limit=1)

     if len(results) > 0 :
       matched_user = results[0]
       logging.info('i am in with'+' hELLO' ) 
    
       newmatching= Matching(sender=userkey, sender_details= self.session['sender_key'], transporter=matched_user.key())
       matchingkey=newmatching.put()
       self.session['matchingkey'] = matchingkey
       doRender(self, 'matching.html', {'matching_account' : newmatching.transporter.account, 'matching_email' : newmatching.transporter.email, 'sender_matching_flag' : True, 'sender_from' : newmatching.sender_details.from_, 'sender_to' : newmatching.sender_details.destination })
       return

   if transporterflag:
          
     matches = Matching.all().filter('transporter = ', userkey).fetch(10)
     
     logging.info('i am in ')


     if len(matches) > 0 :
       logging.info('i am in with'+' hELLO tran' ) 
    
       doRender(self, 'matching.html', {'transporter_list' : matches, 'transporter_matching_flag' : True })
       return
     else:
        doRender(self, 'matching.html', {'transporter_matching_flag' : True , 'error' : 'No Messages for you'})

class SenderHistoryHandler(webapp2.RequestHandler):

   def get(self):
      self.session=Session() 
      senderflag= self.session['senderflag']
      transporterflag = self.session['transporterflag']
      userkey=self.session['userkey']
      username=self.session['username']
   
      if senderflag:          
          matches = Matching.all().filter('sender = ', userkey).fetch(10)     
          logging.info('i am in ')

          if len(matches) > 0 :
            logging.info('i am in with'+' hELLO sender' )     
            doRender(self, 'matching.html', {'sender_list' : matches, 'sender_messages_flag' : True })
            return

          else:
            doRender(self, 'matching.html', {'sender_messages_flag' : True , 'error' : 'No History'})

class MainHandler(webapp2.RequestHandler):

  def get(self):
    if doRender(self,self.request.path) :
      return
    doRender(self,'login.html')


def main():
  application = webapp2.WSGIApplication([
     ('/login', LoginHandler),
     ('/apply', ApplyHandler),
     ('/MainPage', MainPageHandler),
     ('/ChangeDetails', ChangeDetailsHandler),
     ('/matching', MatchingHandler),
     ('/logout', LogoutHandler),
     ('/sender', SenderHandler),
     ('/SenderHistory', SenderHistoryHandler),
     ('/transporter', transporterHandler),
     ('/.*', MainHandler)],
     debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
