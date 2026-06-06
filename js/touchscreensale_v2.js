$(document).ready(function() {
    /**
     * UI Enhancements for Touchscreen Sale V2
     */

    // 1. Sync "Charge" button total with the overall total display
    const totalDisplay = document.querySelector('#overalltotalamount');
    if (totalDisplay) {
        const observer = new MutationObserver(function() {
            const total = $(totalDisplay).text();
            $('.total-placeholder').text(total);
        });
        observer.observe(totalDisplay, { childList: true, characterData: true, subtree: true });
        
        // Initial sync
        $('.total-placeholder').text($(totalDisplay).text());
    }

    // 2. Handle "Show More" categories popup (Only show hidden categories)
    const updateCategoriesOverflow = () => {
        const $categories = $('#categories');
        const $moreBtn = $('#show-more-categories');
        const parentOffset = $categories.offset();
        if (!parentOffset) return;
        
        const parentWidth = $categories.width();
        const parentRight = parentOffset.left + parentWidth;
        
        let hasOverflow = false;
        $categories.find('.category-btn').each(function() {
            const $btn = $(this);
            const btnRight = $btn.offset().left + $btn.outerWidth();
            // If the button's right edge is beyond the parent's right edge (with buffer)
            if (btnRight > parentRight - 10) { 
                hasOverflow = true;
                $btn.css('visibility', 'hidden'); // Hide it visually but keep in DOM for logic
            } else {
                $btn.css('visibility', 'visible');
            }
        });

        if (hasOverflow) {
            $moreBtn.show();
        } else {
            $moreBtn.hide();
        }
    };

    // Watch for dynamic category loading
    const observer = new MutationObserver(() => {
        setTimeout(updateCategoriesOverflow, 100);
    });
    
    if ($('#categories')[0]) {
        observer.observe($('#categories')[0], { childList: true });
    }

    $('#show-more-categories').on('click', function(e) {
        e.stopPropagation();
        const $categories = $('#categories');
        const parentOffset = $categories.offset();
        const parentRight = parentOffset.left + $categories.width();
        
        $('#all-categories-list').empty();
        
        $categories.find('.category-btn').each(function() {
            const $btn = $(this);
            const btnRight = $btn.offset().left + $btn.outerWidth();
            
            if (btnRight > parentRight - 10) { 
                const $clone = $btn.clone();
                $clone.removeClass('active');
                $clone.css('visibility', 'visible'); // Ensure it's visible in the popup
                $('#all-categories-list').append($clone);
            }
        });
        
        if ($('#all-categories-list').children().length > 0) {
            $('#categories-popup').addClass('show');
        }
    });

    // Close popup when clicking outside
    $(document).on('click', function(e) {
        if (!$(e.target).closest('#categories-popup, #show-more-categories').length) {
            $('#categories-popup').removeClass('show');
        }
    });

    // 3. Handle category selection from popup
    $('#all-categories-list').on('click', '.category-btn', function() {
        const categoryId = $(this).data('id');
        // Trigger the original button click to use the existing JS logic
        $('#categories').find(`.category-btn[data-id="${categoryId}"]`).click();
        $('#categories-popup').removeClass('show');
    });

    // 4. Action Icon Functionality Hooks
    $('#locksystem_v2').on('click', function() {
        $('#locksystem').click(); // Trigger original lock logic
    });

    $('#settings_v2').on('click', function() {
        $('#printersettings').click(); // Trigger original settings logic
    });

    // 5. Resizable Split-Pane Layout Logic (Mouse & Touch compatible)
    (function() {
        console.log("Initializing Resizable Split-Pane...");
        const $handle = $('#resize-handle');
        const $sidebar = $('.cart-sidebar');
        const $main = $('.main-pos-container');
        
        console.log("Handle found:", $handle.length);
        console.log("Sidebar found:", $sidebar.length);
        console.log("Main container found:", $main.length);
        
        if ($handle.length && $sidebar.length && $main.length) {
            let isResizing = false;
            
            // Load saved width from localStorage if present
            const savedWidth = localStorage.getItem('pos_sidebar_width');
            if (savedWidth) {
                const widthVal = parseInt(savedWidth);
                if (widthVal >= 320 && widthVal <= 800) {
                    $sidebar.css('width', widthVal + 'px');
                    $handle.css('right', widthVal + 'px');
                    $main.css({
                        'width': `calc(100% - ${widthVal}px)`,
                        'margin-right': widthVal + 'px'
                    });
                }
            }
            
            function startResize(e) {
                console.log("Resize started");
                isResizing = true;
                $handle.addClass('resizing');
                $('body').css('cursor', 'col-resize').css('user-select', 'none');
                e.preventDefault();
            }
            
            function performResize(clientX) {
                const newWidth = $(window).width() - clientX;
                console.log("Resizing. ClientX:", clientX, "Calculated Width:", newWidth);
                
                if (newWidth >= 320 && newWidth <= 800) {
                    $sidebar.css('width', newWidth + 'px');
                    $handle.css('right', newWidth + 'px');
                    $main.css({
                        'width': `calc(100% - ${newWidth}px)`,
                        'margin-right': newWidth + 'px'
                    });
                    localStorage.setItem('pos_sidebar_width', newWidth);
                }
            }
            
            function stopResize() {
                if (isResizing) {
                    console.log("Resize stopped");
                    isResizing = false;
                    $handle.removeClass('resizing');
                    $('body').css('cursor', '').css('user-select', '');
                }
            }
            
            // Mouse Events
            $handle.on('mousedown', startResize);
            $(document).on('mousemove', function(e) {
                if (isResizing) performResize(e.clientX);
            });
            $(document).on('mouseup', stopResize);
            
            // Touch Events
            $handle.on('touchstart', function(e) {
                if (e.originalEvent.touches && e.originalEvent.touches.length) {
                    startResize(e);
                }
            });
            $(document).on('touchmove', function(e) {
                if (isResizing && e.originalEvent.touches && e.originalEvent.touches.length) {
                    performResize(e.originalEvent.touches[0].clientX);
                }
            });
            $(document).on('touchend touchcancel', stopResize);
        }
    })();
});
