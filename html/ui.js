/*
🐺 LXR Book - UI Script
© 2026 iBoss21 / The Lux Empire | wolves.land
*/

// ═══════════════════════════════════════════════════════════════════════════════
// STATE & VARIABLES
// ═══════════════════════════════════════════════════════════════════════════════

let currentBooks = {};
let currentBookId = null;
let currentLocale = {};
let maxPages = 50;

// ═══════════════════════════════════════════════════════════════════════════════
// MESSAGE HANDLER
// ═══════════════════════════════════════════════════════════════════════════════

window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'openBuilder') {
        currentBooks = data.books || {};
        maxPages = data.maxPages || 50;
        currentLocale = data.locale || {};
        openBookBuilder();
    } else if (data.action === 'openViewer') {
        currentLocale = data.locale || {};
        openBookViewer(data.book);
    } else if (data.action === 'closeViewer') {
        closeBookViewer();
    }
});

// ═══════════════════════════════════════════════════════════════════════════════
// BOOK BUILDER
// ═══════════════════════════════════════════════════════════════════════════════

function openBookBuilder() {
    $('#bookBuilder').fadeIn(300);
    renderBooksList();
    clearEditor();
}

function closeBookBuilder() {
    $('#bookBuilder').fadeOut(300);
    $.post('https://lxr-book/close', JSON.stringify({}));
}

function renderBooksList() {
    const container = $('#booksList');
    container.empty();
    
    const bookArray = Object.values(currentBooks);
    
    if (bookArray.length === 0) {
        container.html('<p class="no-books">No saved books</p>');
        return;
    }
    
    bookArray.forEach(book => {
        const item = $('<div>')
            .addClass('book-item')
            .attr('data-book-id', book.id)
            .text(book.title)
            .on('click', function() {
                loadBook(book);
            });
        
        if (book.id === currentBookId) {
            item.addClass('active');
        }
        
        container.append(item);
    });
}

function loadBook(book) {
    currentBookId = book.id;
    
    // Update active state
    $('.book-item').removeClass('active');
    $(`.book-item[data-book-id="${book.id}"]`).addClass('active');
    
    // Load book data into editor
    $('#bookTitle').val(book.title);
    
    // Clear and add pages
    $('#pagesContainer').empty();
    book.pages.forEach((page, index) => {
        addPageToEditor(page.url, index + 1);
    });
    
    updatePageCount();
}

function clearEditor() {
    currentBookId = null;
    $('#bookTitle').val('');
    $('#pagesContainer').empty();
    $('.book-item').removeClass('active');
    updatePageCount();
}

function addPageToEditor(url = '', pageNum = null) {
    const container = $('#pagesContainer');
    const count = container.children().length + 1;
    const pageNumber = pageNum || count;
    
    const pageItem = $(`
        <div class="page-item" data-page="${pageNumber}">
            <div class="page-item-header">
                <span class="page-number">Page ${pageNumber}</span>
                <button class="btn btn-danger btn-sm remove-page-btn">Remove</button>
            </div>
            <input type="text" class="form-control page-url" placeholder="Enter image URL..." value="${url}">
        </div>
    `);
    
    pageItem.find('.remove-page-btn').on('click', function() {
        pageItem.remove();
        renumberPages();
        updatePageCount();
    });
    
    container.append(pageItem);
    updatePageCount();
}

function renumberPages() {
    $('#pagesContainer .page-item').each(function(index) {
        $(this).attr('data-page', index + 1);
        $(this).find('.page-number').text('Page ' + (index + 1));
    });
}

function updatePageCount() {
    const count = $('#pagesContainer .page-item').length;
    $('#pageCount').text(count);
    $('#maxPages').text(maxPages);
}

function getBookData() {
    const title = $('#bookTitle').val().trim();
    const pages = [];
    
    $('#pagesContainer .page-item').each(function() {
        const url = $(this).find('.page-url').val().trim();
        if (url) {
            pages.push({ url: url });
        }
    });
    
    return {
        id: currentBookId,
        title: title,
        pages: pages
    };
}

// ═══════════════════════════════════════════════════════════════════════════════
// BOOK VIEWER
// ═══════════════════════════════════════════════════════════════════════════════

function openBookViewer(bookData) {
    $('#bookViewer').fadeIn(300);
    $('#viewerTitle').text(bookData.title);
    
    // Clear magazine
    $('#magazine').empty();
    
    // Add pages
    bookData.pages.forEach((page, index) => {
        const pageDiv = $('<div>')
            .addClass('page')
            .append($('<img>').attr('src', page.url));
        
        $('#magazine').append(pageDiv);
    });
    
    // Initialize Turn.js
    $('#magazine').turn({
        width: 700,
        height: 500,
        autoCenter: true,
        duration: 1000,
        pages: bookData.pages.length,
        when: {
            turned: function(event, page, pageObject) {
                $('#currentPage').text(page);
            }
        }
    });
    
    // Set page info
    $('#currentPage').text('1');
    $('#totalPages').text(bookData.pages.length);
    
    // Set durability
    updateDurability(bookData.durability, bookData.maxDurability);
}

function closeBookViewer() {
    // Destroy Turn.js instance
    if ($('#magazine').turn('is')) {
        $('#magazine').turn('destroy');
    }
    
    $('#bookViewer').fadeOut(300);
    $.post('https://lxr-book/close', JSON.stringify({}));
}

function updateDurability(current, max) {
    const percentage = (current / max) * 100;
    
    $('#durabilityText').text(`Condition: ${current}/${max}`);
    $('#durabilityFill').css('width', percentage + '%');
    
    // Update color based on percentage
    const fill = $('#durabilityFill');
    fill.removeClass('high medium low');
    
    if (percentage > 66) {
        fill.addClass('high');
    } else if (percentage > 33) {
        fill.addClass('medium');
    } else {
        fill.addClass('low');
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EVENT HANDLERS
// ═══════════════════════════════════════════════════════════════════════════════

$(document).ready(function() {
    // Close buttons
    $('#closeBuilder').on('click', closeBookBuilder);
    $('#closeViewer').on('click', closeBookViewer);
    
    // Add page button
    $('#addPageBtn').on('click', function() {
        const count = $('#pagesContainer .page-item').length;
        if (count >= maxPages) {
            // Show error
            return;
        }
        addPageToEditor();
    });
    
    // Save book
    $('#saveBookBtn').on('click', function() {
        const bookData = getBookData();
        
        if (!bookData.title) {
            return;
        }
        
        if (bookData.pages.length === 0) {
            return;
        }
        
        $.post('https://lxr-book/saveBook', JSON.stringify(bookData), function(response) {
            if (response.success) {
                // Update book ID if new
                if (!currentBookId) {
                    currentBookId = response.bookId;
                    bookData.id = response.bookId;
                }
                
                // Update books list
                currentBooks[bookData.id] = bookData;
                renderBooksList();
            }
        });
    });
    
    // Bind book
    $('#bindBookBtn').on('click', function() {
        const bookData = getBookData();
        
        if (!bookData.title || bookData.pages.length === 0) {
            return;
        }
        
        $.post('https://lxr-book/bindBook', JSON.stringify(bookData), function(response) {
            if (response.success) {
                // Success handled by server notification
            }
        });
    });
    
    // Delete book
    $('#deleteBookBtn').on('click', function() {
        if (!currentBookId) {
            return;
        }
        
        if (!confirm('Are you sure you want to delete this book?')) {
            return;
        }
        
        $.post('https://lxr-book/deleteBook', JSON.stringify({ bookId: currentBookId }), function(response) {
            if (response.success) {
                delete currentBooks[currentBookId];
                renderBooksList();
                clearEditor();
            }
        });
    });
    
    // Viewer navigation
    $('#prevPage').on('click', function() {
        $('#magazine').turn('previous');
    });
    
    $('#nextPage').on('click', function() {
        $('#magazine').turn('next');
    });
    
    // ESC key handling
    $(document).on('keyup', function(e) {
        if (e.key === 'Escape') {
            if ($('#bookBuilder').is(':visible')) {
                closeBookBuilder();
            } else if ($('#bookViewer').is(':visible')) {
                closeBookViewer();
            }
        }
    });
});
