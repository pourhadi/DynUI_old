DynUI
====
DynUI is a style-based theme library for iOS apps. The objective was to create a way to style an iOS app UI without needing any custom graphics, which add to the app's footprint, and makes adjusting the theme of an app a tedious process.

Here's the basic process:

- Create your styles, either programmatically or with the soon-to-be-available DynUI Editor for OS X.
- Then, assign the styles to their appropriate views.

DynUI is designed to style most of the standard iOS UI components, including (but not limited to):

- UIViews (and subclasses)
- UIButtons (control states)
- UINavigationBars
- UIBarButtonItems
- UITableViews
- UITableViewCells (plain and grouped)
- UICollectionViewCells
- UISearchBars
- UISliders
- UIPopovers
- UITextFields
- UILabels

DynUI also provides for styling of graphics -- create a style, then apply the style to a UIImage. The style will be masked onto the image (graphics, shadows, borders, etc), allowing you to use a single style to alter the appearance of a series of images -- i.e., all the images in a UITabBar -- so you don't have to modify every single image file every time you need to make a design change.

Icons
====
DynUI also comes with 266 vector icons for use with the library, which can be styled and presented as images in your interface. 

© 2013 Dan Pourhadi. All rights reserved.
