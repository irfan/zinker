[zinker - rapidshare batch downloader](http://github.com/irfan/zinker/) 
======================================================================================
    @Project : zinker - rapidshare batch downloader
    @Author  : Irfan Durmus http://irfandurmus.com/
    @Code    : http://github.com/irfan/zinker/

### How to use 
    ./zinker.sh <username> <password> <rapidshare-url-list.txt>
    I just wrote it in couple of hours. I tried to make it securely, but still could be have some problem.
    Please dont forget to delete the tmp directory after used this script. Your user information will be store in the tmp, so it is important.
    Please notify me if you found a bug!
    Happy coding!

After use you will have
--------------------------------------
- log file under ./tmp directory
- cookie file under ./tmp directory
- you'll find the downloaded files into the downloads directory


### Lines of the example log file (Of course the urls are masked)

    2012-08-02 01:57:52 Download started : http://rapidshare.com/files/1000/70.zip > /Users/irfan/projects/zinker/downloads/70.zip
    2012-08-02 01:58:08 Download finised : http://rapidshare.com/files/1000/70.zip > /Users/irfan/projects/zinker/downloads/70.zip
    2012-08-02 01:58:08 Download started : http://rapidshare.com/files/2000/80.zip > /Users/irfan/projects/zinker/downloads/80.zip
    2012-08-02 01:58:22 Download finised : http://rapidshare.com/files/2000/80.zip > /Users/irfan/projects/zinker/downloads/80.zip
    2012-08-02 01:58:22 Download finished, here is the summary :
    2012-08-02 01:58:22 ________________________________________
    2012-08-02 01:58:22 Total Links : 2 
    2012-08-02 01:58:22 Downloaded : 2 
    2012-08-02 01:58:22 Passed : 0 
    2012-08-02 01:58:22 Error : 0 
    2012-08-02 01:58:22 Download Folder : /Users/irfan/projects/zinker/downloads
    2012-08-02 01:58:22 Log File : /Users/irfan/projects/zinker/tmp/log-20120802015751.txt
    2012-08-02 01:58:22 Used cookie : /Users/irfan/projects/zinker/tmp/cookie-20120802015751.txt
    2012-08-02 01:58:22 ________________________________________
