# Admin Install Guide

## Initial Considerations/Setup
1. Determine which type of main navigation and page specific navigation you want for your site.
2. Upload files from the Template you choose into /. You can upload the zip file unzipped with the option in the upload menu.

### RSS Setup
1. In the top menu select Content > RSS
2. Click the + New button
3. Path: [/_resources/rss/news.xml](/_resources/rss/news.xml)
4. Enter a Title and Description
5. Link: Enter the production url for this site followed by [/_resources/rss/news.xml](/_resources/rss/news.xml)
6. Item Count: Enter 9999

### Create the Site Nav Asset
1. Go to Content > Assets
2. Click the + New button
   - Type: Web Content or Plain Text
   - Name: Auto Publish
   - Asset Content: leave blank
   - Select Lock to site.
3. Copy the asset number from the Content > Assets table DM Tag column. (looks like {{a:143536}}).

### Create a News - Homepage Asset
1. Navigate to Content > Assets
2. Click the green + New button
   - Type: Source Code
   - Check: Lock to site
   - Asset Content: 
     ```
     <rss-feed feed="/_resources/rss/news.xml" 
	     description="false"
	     dates="true"
	     dateFormat="D F j, Y"
	     limit="10"
	     pagination="true"/>
     ```
     
### Configure the Site Nav
There are two parts to configuring the Site nav.  The first part is editing the page Parameters which set the look and feel.  The second part, which may not be necessary depending on your site's set up, consists of using the OU Editor to manually add items to the site's menu.

#### Parameters for Site Nav
Editing the parameters may seem confusing at first.  The good part about the site map is that you can experiment with different setups depending on what your clients want.  When you republish the sitemap it will automatically update on each page of the site.
1. Go to [/_resources/includes/_site-nav.inc](/_resources/includes/_site-nav.inc)
2. Check out the page by clicking the 💡 light-bulb icon
3. Click the Properties button to edit page properties
4. Select the <> Parameters button from the left-hand menu
5. Under Custom Settings then Main Navigation select from the following options:
   - Menu to use: 
     a. Yamm - a mega-menu that displays listing of all the files and directories of your site.  Ordered alphabetically in ascending order.
     b. Bootstrap - a [bootstrap nav menu](https://getbootstrap.com/docs/3.3/components/#navbar) that displays a listing of directories and files on the main level and up to one level deep for directories as a dropdown menu.  The listings for main and sub menus is alphabetic by name.
     c. Simple - a Bootstrap nav menu that list files and directories at site root. Sub folder items will not be listed. Ordered alphabetically in ascending order.     
   - Auto-create Nav: Uncheck this option to turn off auto creating the navs.  This means you will enter your own HTML for the site nav menu.      
   - Files to ignore: These filenames will be ignored. Both the filename and extension must be entered (Files beginning with . or _, robots.txt and index files are automatically ignored).
   - Directories to ignore: These directories will be ignored.  Directories must be comma-delimited. (Image directories "images" and directories beginning in a _ or . are automatically ignored).
   - Hide all children: Enter a comma delimited list of directories for which you don't want to display the children.  This is useful for News and Directory sections.
   - Root Directory order: Overwrite the order of directories in the root by entering the directory names (comma delimited) in the order that you want them to appear.   
6. Under Custom Settings then Side Navigation select from the following options:
   - Sidenav to use: 

#### Edit Site Nav to add additional links 
Use this option only when you want to manually add items to the site's nav.  This can be done if none of the auto-create options work for you or if you want to add items to the menu that are not in the automatic file listing.
1. Go to [/_resources/includes/_site-nav.inc](/_resources/includes/_site-nav.inc)
2. Check out the page by clicking the 💡 light-bulb icon
3. Click the Edit button to edit page content
4. Find the green Main Content button and click it.
5. Create an unordered list of links.  You may nest items if you wish.  (Note: even is you choose the simple nav, if you nest items they will show up as a drop down, not a simple nav).
6. Click the Save button (looks like a floppy disk in the editor menu).

#### Autopublish
Use this option only when you want to manually add items to the site's nav.  This can be done if none of the auto-create options work for you or if you want to add items to the menu that are not in the automatic file listing.
1. Go to [/_resources/includes/_site-nav.inc](/_resources/includes/_site-nav.inc)
2. Check out the page by clicking the 💡 light-bulb icon
3. Click the Edit button to edit page content
4. Find the green Auto Publish Asset button at the bottom of the page and click it.
5. Click the Insert Asset button
6. Select your Auto Publish Sitenav asset.
7. Click the Save button (looks like a floppy disk in the editor menu).


## Site Configuration (Setup > Sites)

### Groups (Setup > Groups)
- Create a group and name it the same as the site name. Refer to this below as (site group name).
- Do a global find and replace under Content > Find and Replace
  1. Find: group="Everyone"
  2. Replace With: group="(site group name)"
  3. Click the Preview Replace button
  
### Global Variables
1. Hover over your website's name
2. Select Edit > Site Access
3. Recursive Modification: Select "Apply Selected Settings to All Existing Files and Folders in the Site"
   - Access Group: (site group name)
   - URL Type: Root-Relative
4. Under RSS Feeds (If you are using RSS feeds)
   - [/_resources/news](/_resources/news)
5. Under Directory Variables:
   - Click the Add button.
   - Change Publish, Default Image Folder and Default Media Folder
   - Publish: skip:xsl,tcf,tmpl,.skip.py,.skip.js
   - Default Image Folder: [/_resources/images](/_resources/images)
   - Default Media Folder: [/_resources/images/media](/_resources/images/media)

### Recursively set the following files/directories to "Administrators Only"
- .htaccess
- robots.txt
- [/_resources/templates](/_resources/templates)
- [/_resources/ou](/_resources/ou)
- [/_resources/php](/_resources/php)

### File Setup
1. [/_props.pcf](/_props.pcf)
   - Check out the [/_props.pcf](/_props.pcf) file and edit the Page Title field to be the same as the site name.
2. [/.htaccess](/.htaccess)
   - Check out [/.htaccess](/.htaccess)
   - Find the "eits-demo.domain-account.com" text and replace it with the URL of your site
3. [/index.pcf](/index.pcf)
   - Edit [/index.pcf](/index.pcf)
   - Scroll down the page and click the green Middle Content button
   - Delete the old asset and insert the News - Homepage asset

### Delete the following files
Go to the Production Server via Content > Pages and clicking on the Production button beside Staging (default):
- index.htm
- missing.html
- data/
- logs/
- cgi-bin/
- scripts/

### Publish the following files
- robots.txt
- .htaccess file
- /_resources folder
- index.pcf

### Adding Gadgets to your site
You should install the Bookmarks and Notes gadgets, as these are helpful for documentation and for quick finding of important links.
1. In the top menu select Add-Ons > Marketplace.
2. In the web page that displays there is a Categories menu at the top. Select Gadgets.
3. Install all the gadgets you want available on your site.
4. In the top menu select Setup > Gadgets
5. You can edit individual gadgets here.
6. You can add your own gadgets if you wish.  Here are some tutorials:
   - [https://developers.omniupdate.com/](https://developers.omniupdate.com/)
   - [https://eits.uga.edu/protected/oudocs/gadgets/index.html](https://eits.uga.edu/protected/oudocs/gadgets/index.html)
7. A helpful custom Gadget is the Check-In Gadget
   - Select Setup > Gadgets
   - Click the green + New button
   - Paste https://eits.uga.edu/_resources/gadgets/gadget-check-in/ in the text box
   - Configure the properties based on whom you want to be able to use it.

### Snippets (Content > Snippets)
1. Category: Bootstrap 
   - Name: Accordion Menu
   - File: [/_resources/snippets/ouaccordion-table.html](/_resources/snippets/ouaccordion-table.html)
   
   - Name: Jumbotron
   - File: [/_resources/snippets/jumbotron.html](/_resources/snippets/jumbotron.html)
2. Category: Images
   - Snippets
     Name: Image with Caption
     File: [/_resources/snippets/caption-image.html](/_resources/snippets/caption-image.html)
3. Category: Table Transformations
   - Snippets
     Name: 3x3 Section Grid
     File: [/_resources/snippets/section-link-table-3x3.html](/_resources/snippets/section-link-table-3x3.html)
     
     Name: Arrow Tabs
     File: [/_resources/snippets/arrow-tabs.html](/_resources/snippets/arrow-tabs.html)
     
### Configure Google Custom Search at WWW Root 
The template comes with a file called search.pcf that is located in WWW root.  The following steps will configure the search.  If you want the search.pcf in another directory, follow the steps under "Changing Path of search.pcf"
You must have a google account to install the Google Custom Search.  We recommend partnering with EITS or creating a departmental Google Account rather than using your personal account to create the custom search.
1. Visit [https://cse.google.com/cse/create/new](https://cse.google.com/cse/create/new)
2. Under "Sites to search", type in your website's URL
3. Under "Name of the search engine", create a unique name that will identify this website search engine to you.
4. Click the blue "Create" button.
5. There is a sidebar to the left of the main content.  Click "Edit Search engine"
6. Select "Look and feel"
7. Click the "Results Only" box
8. Click the "Save & Get Code" button.
9. Copy the auto-generated text you are given.
10. Within Omniupdate
	1. Go to the [/search.pcf](/search.pcf) file
	2. Click the Source button once the page is checked out to you.
	3. Within the <bodycode></bodycode> tag place the entire contents of the ```<script>...</script>``` minus the ```<gcse:searchresults-only></gcse:searchresults-only>``` tag.
	4. Paste the following XML tag into the ```<ouc:div label="maincontent">``` before the ending ```</div>``` tag: ```<gcsesearchresultsonly/>```
	5. Save the file.
	
#### Changing Path of search.pcf
1. Move search.pcf to the directory that you want it to remain and copy the file's path beginning at WWW root.
2. Check out [/_resources/includes/search.inc](/_resources/includes/search.inc)
3. Replace the text in the ```<form>``` tag's action parameter to the new path of search.pcf
4. Save and publish the file.

### Versioning
Once you have made all your changes, you are going to want to save the current version of the site, just in case a user deletes something they shouldn't.  It is a good idea to periodically save site versions in case files are lost. These are instructions for saving the site's current version:
1. Go to Setup > Sites
2. Hover the mouse over the row(s) of site names.
3. An Edit, Publish, Scan and Actions menu will pop up under the Last Save/Options column.
4. Under Actions click Save Version
5. Enter a version description and click OK
6. A message will pop up at the bottom of the screen saying, "Site (your site name) is being committed to version control. You will receive another notification when the operation is complete."

## Additional Modules
The following are optional enhancements to the basic site.

### News
Additional steps are needed when creating news sections. Once you complete these steps you may add items to the section.
1. Create a News RSS Feed
   - In the top menu select Content > RSS
   - Click the + New button
   - Path: [/_resources/rss/news.xml](/_resources/rss/news.xml)
   - Enter a Title and Description
   - Link: Enter the production url for this site followed by [/_resources/rss/news.xml](/_resources/rss/news.xml)
   - Item Count: Enter 9999
2. Create a News Section
   - In the top menu select Content > Pages
   - Click the + New button and select News Section
   - Enter the information in the form and make sure the RSS feed is set to [/_resources/rss/news.xml](/_resources/rss/news.xml)
     This will create several files.  The index.pcf file will have an RSS feed associated with it.
     
     To associate the [/_resources/rss/news.xml](/_resources/rss/news.xml) with the items that you create in this section do the following:
   	 - Browse out to the parent directory
   	 - Hover over the directory name with the mouse.
   	 - An Edit, Publish, File menu will show up under the Options column in the file listing.
   	 - Hover over the Edit menu that becomes visible.
   	 - This will display another menu.  Click Access
   	 - Scroll down to RSS Feed on the modal window that pops up.  
   	 - Select the [/_resources/rss/news.xml](/_resources/rss/news.xml) feed.
   	 - Click Save.   	 

#### Adding News Items to a News Section
1. Within the News Section click the + New button.
2. Enter the information requested in the modal window.
3. If you have a faculty/staff/student that this news article was written by or mentions you may tag them here.
   - Tagging people has the effect of showing up articles that they wrote within their profile page in the Faculty/Staff/Student Directory

### Faculty/Staff/Student Directory
If you want a faculty/staff/student directory, you need to create a directory feed and a directory section.

The Directory uses page tagging extensively.  Each index.pcf will that you associate a tag such as faculty, staff, student etc. will show a listing of that category. This index.pcf must be republished when adding or removing people.
1. Create a Directory Feed
   - In the top menu select Content > RSS
   - Click the + New button
   - Path: [/_resources/rss/directory.xml](/_resources/rss/directory.xml)
   - Enter a Title and Description
   - Item Count: Enter 9999	
2. Create a Directory/Faculty & Staff Directory Section
   - In the top menu select Content > Pages
   - Click the + New button and select either Directory Section or Faculty & Staff Directory Section
   - Listing Category: Applies tags to the page based on this field.
   - Enter the information in the form and make sure the RSS feed is set to [/_resources/rss/directory.xml](/_resources/rss/directory.xml)
   - The categories to be displayed on the index.pcf file are set by OU tags.  This means that they are displayable anywhere on the site simply be referencing the tag that the page was created with.
4. Create groups for faculty, staff, students and whoever else you will need to access the pages and do updates in this directory.
5. The default group name for the Directory Sections is "Faculty". You can replace these by doing a global Find/Replace and change  group="Faculty" to group="whatever group".  You can restrict the Find/Replace to only do this for certain directories or files.   	

### Calendar/Calendar Events
Both the Calendar and Events can share the same feed if you desire.  If you want them to share the same feed, you will need to change the default path in [/_resources/ou/templates/events/event.tcf](/_resources/ou/templates/events/event.tcf) to the same feed used by the Calendar
1. Create an Events Feed
   - Click the + New button
   - Path: [/_resources/rss/events.xml](/_resources/rss/events.xml)
   - Enter a Title and Description
   - Link: Enter the production url for this site followed by [/_resources/rss/events.xml](/_resources/rss/events.xml)
   - Item Count: Enter 9999

2. Calendar Events (you may need to make separate assets for both the Events with Calendar and the Events without Calendar).
   * This asset can be either displayed stand alone (in which case it requires a feed attribute), or with a Calendar asset.
   * Required attributes when used as a stand-alone calendar are: feed
   * To make the Events stand alone, add a feed attribute.  If the Events will be displayed on the same page as a Calendar asset do not provide a feed.

   Type: Source Code
   Asset Content (normal Events):
   ```
   <calendar-events/> 
   ```

   Asset Content (stand alone Events):
   ```
   <calendar-events-only 
   feed="http://status.uga.edu/rss/feed.xml" 
   maxEvents="5" 
   eventNumberOfDays="12" 
   showPagination="true" 
   eventDescLength="100" 
   showHeading="false" />
   ```
   
3. Calendar (you may need to make separate assets for both the Calendar and the Calendar (stand alone).
   * See  [/_resources/js/calendar/ReadMe.html](/_resources/js/calendar/ReadMe.html) for documentation on this asset.
   * Can be created to be either stand-alone or accompanied by the Events asset.
   * Required attributes for the calendar are: feed
   * To make the calendar a stand alone calendar, give it a relative eventsRedirect URL (such as eventsRedirect="/about/calendar/").
  
   Parameters:
   - feed: Either an absolute or relative URL.  
  	 * Can also take a 'sort' parameter which is either the value 'asc' or 'desc'. The default is 'asc' if no parameter is given.
	  
   Type: Source Code
   Asset Content (normal calendar): 
	  
   ```
   <calendar 
  	 feed="(enter the calendar feed URL)" 
  	 maxEvents="5" 
  	 eventNumberOfDays="12" />
   ```
	  
   Asset Content (stand alone calendar):  
   ```
   <calendar-only 
  	 feed="(Enter the calendar feed root-relative or absolute URL)[&sort=asc|desc]" 
  	 maxEvents="5" 
  	 eventNumberOfDays="12" 
  	 eventsRedirect="/about/calendar/" />
   ```
	  
### Google Static Map
1. Go to [https://developers.google.com/maps/documentation/javascript/get-api-key](https://developers.google.com/maps/documentation/javascript/get-api-key)
2. Register for an API key.  Copy the API Key for use in the creating the asset.
3. Go to https://maps.google.com and enter the Street Address for the map you want to show.
4. You will see a map and in the URL an address similar to this: 
   ```
   https://www.google.com/maps/place/101+Cedar+St,+Athens,+GA+30602/@33.9451511,-83.3739854,17z/data=!3m1!4b1!4m5!3m4!1s0x88f66ce44e34ce13:0x46140e17cd38f0f0!8m2!3d33.9451467!4d-83.3717914
   ```
5. Copy the latitude and longitude from the URL. It should look like 33.9451511,-83.3739854.
6. Create a new Asset with the following settings:
   Type: Source Code
   Name: Google Map
   Description: Simple Google Map. Requires an api-key attribute.
   Asset Content:
   ```
   <google-static-map center="( Enter the Street Address )"
      api-key="( Enter API KEy )"
      size="450x450" 
      zoom="14" 
      marker="color:red;label:E;latlng:(Enter the Latitude and Longitude);size:small" 
      description="( Enter the map description )" />
   ```

### Other Assets (Content > Assets)

#### Publish Site Menu
- Type: Web Content or Plain Text
- Name: Auto Publish Menus
- Asset Content: leave blank

	  
#### News
- Type: Source Code
- Asset Content: 
  ```
  <rss-feed feed="https://eits.uga.edu/rss/news.xml" 
	  description="false"
	  dates="true"
	  dateFormat="D F j, Y"
	  limit="10"
	  pagination="true"/>
  ```
  
- Properties:
  - feed (required): string - Either a relative (begins with a slash) or 
  - description: boolean - show or hide description from RSS 
  - dates: boolean - show or hide dates
  - dateFormat: string - PHP date format
  - limit: int -  number of items to show per page
  - pagination: boolean - show or hide pagination links	

## Snippets (Content > Snippets)
- Bootstrap 
  Name: Accordion Menu
  File: [/_resources/snippets/ouaccordion-table.html](/_resources/snippets/ouaccordion-table.html)

  Name: Jumbotron
  File: [/_resources/snippets/jumbotron.html](/_resources/snippets/jumbotron.html)

- Images
  Name: Image with Caption
  File: [/_resources/snippets/caption-image.html](/_resources/snippets/caption-image.html)

- Table Transformations
  Name: 3x3 Section Grid
  File: [/_resources/snippets/section-link-table-3x3.html](/_resources/snippets/section-link-table-3x3.html)

  Name: Arrow Tabs
  File: [/_resources/snippets/arrow-tabs.html](/_resources/snippets/arrow-tabs.html)

	  
### Contact/Email Form
- Edit [/_resources/php/email.php](/_resources/php/email.php).
- Change $sendto PHP variable to your department's email.
- Change $subject PHP variable to the text you would like in the subject line for emails.
- Publish [/_resources/php/email.php](/_resources/php/email.php).
- Create an Asset
  Name: Contact Form
  Type: Source Code
  Asset Content:
  ```
  <contact-us>
	<form name="sentMessage" class="well" id="contactForm">
		<legend class="sr-only">Contact Us</legend>
		<div class="control-group">
			<div class="controls">
				<input type="text" class="form-control" placeholder="Full Name" id="name" required="true" data-validation-required="required" message="Please enter your name"/><p class="help-block"></p>
			</div>
		</div>
		<div class="control-group">
			<div class="controls"><input type="email" class="form-control" placeholder="Email" id="email" required="true" data-validation-required="required" message="Please enter your email"/></div>
		</div>
		<div class="control-group">
			<div class="controls">
				<textarea rows="10" cols="100" class="form-control" placeholder="Message" id="message" required="true" data-validation-required="required" message="Please enter your message" minlength="5" data-validation-minlength-message="Min 5 characters" maxlength="999" style="resize:none"></textarea>
			</div>
		</div>
		<div id="success">&nbsp;</div>
		<button type="submit" class="btn btn-primary pull-right">Send</button><br/>
	 </form>
   </contact-us>
   ```
- Create an Interior Page from the Content > Pages menu and click the + New button
- Select Interior Page
- Name your page and edit the contents, adding the Contact Form asset.

				
## Enable Image Galleries
- Go to Setup > Sites.
- Click on the site name.
- Scroll down to LDP Settings
- Enter 209.212.159.209 in the LDP Admin Host box
- Enter /.ldp in the LDP Gallery Directory box
- Click the Save button

### Enabling features incompatible with WCAG 2.0 Accessibility
1. Republish the [/_resources/ldp](/_resources/ldp) folder
2. This feature works with image galleries assets.  You will need to Enable Image Galleries (above) and then create an image gallery asset.
3. Add these options to the PCF pages that you want to display the gallery in under either the "gallery-type" or the "ldp" parameter (depending on your install).  There may already be an option for "Pretty Photo".
   ```
   <option value="flex" selected="true">Flex Slider</option>
   <option value="pretty" selected="false">Pretty Photo</option>
   <option value="bootstrap" selected="false">Bootstrap</option>
   ```

## Other
* If you need OU Forms on your site, go to Setup > Sites. Click on the site name.  
Scroll down to LDP Settings. Click the Download Reg File button.  
Copy the contents of this file and create a ticket with TeamDynamix for EITS Websites 
and paste this text in the ticket with the request "Add site to OU LDP".

