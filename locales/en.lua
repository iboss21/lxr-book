--[[
    🐺 LXR Book - English Locale
    © 2026 iBoss21 / The Lux Empire | wolves.land
]]

Locale = Locale or {}
Locale['en'] = {
    -- Commands
    ['command_bookbuilder'] = 'Open the book builder',
    ['command_bookbuilder_desc'] = 'Create and manage books (job restricted)',
    
    -- Book Builder UI
    ['builder_title'] = 'Book Builder',
    ['builder_book_title'] = 'Book Title',
    ['builder_title_placeholder'] = 'Enter book title...',
    ['builder_pages'] = 'Pages',
    ['builder_add_page'] = 'Add Page',
    ['builder_page_url'] = 'Page %s URL',
    ['builder_url_placeholder'] = 'Enter image URL...',
    ['builder_remove_page'] = 'Remove',
    ['builder_save'] = 'Save Book',
    ['builder_bind'] = 'Bind to Item',
    ['builder_delete'] = 'Delete Book',
    ['builder_close'] = 'Close',
    ['builder_no_books'] = 'No saved books',
    ['builder_load_book'] = 'Load Book',
    
    -- Book Viewer UI
    ['viewer_title'] = 'Book Viewer',
    ['viewer_page_of'] = 'Page %s of %s',
    ['viewer_prev'] = 'Previous',
    ['viewer_next'] = 'Next',
    ['viewer_close'] = 'Close',
    ['viewer_durability'] = 'Condition: %s/%s',
    
    -- Notifications
    ['no_permission'] = 'You do not have permission to use this command',
    ['no_empty_book'] = 'You need an empty book in your inventory',
    ['book_saved'] = 'Book saved successfully',
    ['book_deleted'] = 'Book deleted successfully',
    ['book_bound'] = 'Book bound to item successfully',
    ['book_title_required'] = 'Book title is required',
    ['book_pages_required'] = 'At least one page is required',
    ['book_max_pages'] = 'Maximum %s pages allowed',
    ['invalid_url'] = 'Invalid image URL',
    ['book_worn_out'] = 'This book is too worn out to read',
    ['book_no_data'] = 'This book has no pages',
    ['builder_opened'] = 'Book builder opened',
    ['viewer_opened'] = 'Book viewer opened',
    
    -- Security
    ['url_not_allowed'] = 'Image host not allowed. Use: imgur.com, discord, postimg.cc',
    ['rate_limit'] = 'Slow down! Too many actions',
    ['invalid_book_data'] = 'Invalid book data',
    
    -- Job
    ['job_required'] = 'This command requires one of these jobs: %s',
    
    -- General
    ['press_to_open'] = 'Press ~INPUT_CONTEXT~ to open book',
    ['press_to_close'] = 'Press ~INPUT_FRONTEND_CANCEL~ to close',
}
