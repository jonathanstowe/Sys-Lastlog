/*
#*****************************************************************************
#*                                                                           *
#*                          Gellyfish Software                               *
#*                                                                           *
#*                                                                           *
#*****************************************************************************
#*                                                                           *
#*      PROGRAM     :  Sys::Lastlog                                          *
#*                                                                           *
#*      AUTHOR      :  JNS                                                   *
#*                                                                           *
#*      DESCRIPTION :  Provide Object(ish) interface to lastlog file         *
#*                                                                           *
#*                                                                           *
#*****************************************************************************
#*                                                                           *
#*      $Log: Lastlog.xs,v $
#*      Revision 1.2  2004/03/02 20:28:07  jonathan
#*      Put back in CVS
#*
#*      Revision 1.1  2001/02/13 08:27:36  gellyfish
#*      Initial revision
#*
#*                                                                           *
#*                                                                           *
#*****************************************************************************
*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <utmp.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <pwd.h>
#include <unistd.h>

#ifdef USE_LASTLOG_H
#include <lastlog.h>
#endif

int get_lastlog_fd(void);

struct lastlog *getllent(void)
{

   static struct lastlog llent;

   int ll_fd;

   if ( (ll_fd =  get_lastlog_fd() ) == -1 )
   {
     return( ( void *)0);
   }

   if(read( ll_fd,&llent, sizeof( struct lastlog )) != sizeof( struct lastlog))
   {
      close(ll_fd);
      return ( (void *)0 );
   }
   else
   {
      return ( &llent );
   }
}

struct lastlog *getlluid(int uid)
{
  static struct lastlog llent;
  int ll_fd;

  off_t where;

  if ( (ll_fd =  get_lastlog_fd() ) == -1 )
  {
     return( ( void *)0);
  }

  where = lseek(ll_fd,0, SEEK_CUR);

  lseek(ll_fd, (off_t)(uid * sizeof( struct lastlog)), SEEK_SET);


  if(read( ll_fd,&llent, sizeof( struct lastlog )) != sizeof( struct lastlog))
  {
      lseek(ll_fd,where, SEEK_SET );
      return ( (void *)0 );
  }
  else
  {
      lseek(ll_fd,where, SEEK_SET );
      return ( &llent );
  }
}

int get_lastlog_fd(void)
{

   static int ll_fd = -1;

   if ( ll_fd = -1 )
   {
     ll_fd = open(_PATH_LASTLOG,O_RDONLY);
   }

   return(ll_fd);
}


void setllent(void)
{
   int ll_fd;

   if ((ll_fd =  get_lastlog_fd()) != -1)
   {
      lseek(ll_fd,0, SEEK_SET);
   }     
}

SV *llent2hashref(IV count, struct lastlog *llent)
{
   HV *ll;
   SV *ll_ref;
   HV *meth_stash;   

   ll = newHV(); 
      
   hv_store(ll,"uid",3,newSViv(count),0);
   hv_store(ll,"ll_time",7,newSViv((IV)llent->ll_time),0);
   hv_store(ll,"ll_line",7,newSVpv(llent->ll_line,0),0);
   hv_store(ll,"ll_host",7,newSVpv(llent->ll_host,0),0);
   meth_stash = gv_stashpv("Sys::Lastlog::Entry",1);
   ll_ref = newRV((SV *)ll);
   sv_bless(ll_ref, meth_stash);

   return(ll_ref);  
}

MODULE = Sys::Lastlog		PACKAGE = Sys::Lastlog		

void
getllent(self)
SV *self
  PPCODE:
    struct lastlog *llent;
    SV *ll_ref;

    static IV count = 0;

    llent = getllent();

    if ( llent )
    {
      ll_ref =  llent2hashref(count++,llent);
      EXTEND(SP,1);
      PUSHs(sv_2mortal(ll_ref));
    }
    else
    {
      XSRETURN_EMPTY;
    }

void
getlluid(self, uid)
SV *self
IV uid
  PPCODE:
    struct lastlog *llent;
    SV *ll_ref;

    static IV count = 0;

    llent = getlluid(uid);

    if ( llent )
    {
      ll_ref = llent2hashref(uid,llent);
      EXTEND(SP,1);
      PUSHs(sv_2mortal(ll_ref));
    }
    else
    {
      XSRETURN_EMPTY;
    }

void
getllnam(self,logname)
SV *self
char *logname
  PPCODE:
    struct passwd *pwd;
    struct lastlog *llent;
    SV *ll_ref;

    if(pwd = getpwnam(logname))
    {
      llent = getlluid(pwd->pw_uid);
      if ( llent )
      {
        ll_ref = llent2hashref(pwd->pw_uid,llent);         
        EXTEND(SP,1);
        PUSHs(sv_2mortal(ll_ref));
      }
      else
      {
        XSRETURN_EMPTY;
      }
    }
    else
    {
      XSRETURN_EMPTY;
    }

void
setllent(self)
SV *self
   PPCODE:
     setllent(); 
