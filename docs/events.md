--[[
    🐺 LXR Book - Events & API Reference
    © 2026 iBoss21 / The Lux Empire | wolves.land
]]

# 📡 Events & API Reference

## Server Events

### lxr-book:server:saveBook
**Type:** Callback  
**Description:** Save a book to player's data  
**Parameters:**
- `bookData` (table) - Book information

### lxr-book:server:getBooks
**Type:** Callback  
**Description:** Get player's saved books  
**Returns:** table of books

### lxr-book:server:deleteBook
**Type:** Callback  
**Description:** Delete a saved book  
**Parameters:**
- `bookId` (string) - Book ID to delete

### lxr-book:server:bindBook
**Type:** Callback  
**Description:** Bind book to physical item  
**Parameters:**
- `bookData` (table) - Book information

### lxr-book:server:useBook
**Type:** Callback  
**Description:** Use a book item (consumes durability)  
**Parameters:**
- `slot` (number) - Item slot
- `itemData` (table) - Item data

## Client Events

### lxr-book:client:notify
**Type:** Event  
**Description:** Display notification to client  
**Parameters:**
- `message` (string) - Message to display
- `type` (string) - Notification type ('success', 'error', 'info')

## NUI Callbacks

### saveBook
**Parameters:** bookData  
**Returns:** {success, bookId}

### deleteBook
**Parameters:** {bookId}  
**Returns:** {success}

### bindBook
**Parameters:** bookData  
**Returns:** {success}

### close
**Description:** Close UI

═══════════════════════════════════════════════════════════════════════════════
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
═══════════════════════════════════════════════════════════════════════════════
