# Private Book Library Store (Online Book Retail System)

This project is an online book retail system for a private library store aiming to expand its reach beyond physical sales. It provides a full-featured Flutter frontend (using GetX for state management) and a .NET Web API backend powered by PostgreSQL.

The system allows users to browse, search, filter, and purchase books online, with special features for members and administrators.



## Key Features

### For Users / Members

* Browse a paginated catalog of books.
* View detailed information about each book.
* Search by title, ISBN, or description; filter by author, genre, availability, price, ratings, language, format, publisher.
* Sort books by title, publication date, price, or popularity (most sold).
* Register as a member.
* Bookmark (whitelist) favorite books.
* Add books to a cart and place cancelable orders.
* Receive a confirmation email with a claim code and bill.
* Pick up the order in-store using the membership ID and claim code.
* Earn discounts:

  * 5% discount on orders of 5 or more books.
  * 10% stackable discount after every 10 successful orders.
* Submit ratings and reviews on purchased books.

### For Staff

* Process claim codes to fulfill member orders.

### For Administrators

* Full CRUD management of the book catalog and inventory.
* Set timed discounts and optionally flag books as "On Sale."
* Create timed announcements (banners) for deals, new arrivals, or special information.
* Broadcast real-time updates when successful orders are placed.



## Tech Stack

* Frontend: Flutter with GetX state management
* Backend: ASP.NET Web API (C#)
* Database: PostgreSQL



## Main Functional Areas

Feature                 Description                                             
Browse Catalog          Paginated book list with filters and sorting            
Book Details            View detailed information per book                      
Member System           Register, bookmark, cart, place and cancel orders       
Discounts               Automatic discounts based on order count and size       
Email Notifications     Claim code and bill sent to registered email            
Staff Portal            Order fulfillment using claim codes                     
Admin Portal            Manage catalog, inventory, discounts, and announcements 



## Project Status

* Core user, staff, and admin features implemented
* Backend integrated with PostgreSQL
* Flutter frontend with GetX for efficient state management


