<div class="home-content d-flex justify-content-between align-items-center pr-4 shadow-sm bg-white flex-nowrap" style="height: 55px; border-bottom: 1px solid #ebecef;">
    <div class="d-flex align-items-center" style="min-width: 0;">
        <i class='bx bx-menu cursor-pointer menu-toggle-icon' style="font-size: 22px; margin-left: 15px; margin-right: 15px; color: #555; flex-shrink: 0;"></i>
        <span class="text font-weight-bold page-header-title" style="font-size: 16px; color: #2c3e50; letter-spacing: -0.2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><?php echo isset($pagename) ? $pagename : 'SalesFlow'; ?></span>
    </div>
    <div class="branch-selector d-flex align-items-center" style="flex-shrink: 0;">
        <div class="dropdown">
            <button class="btn btn-sm d-flex align-items-center bg-white border shadow-sm px-3" type="button" id="branchDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="border-radius: 20px; height: 32px; border-color: #d1d5db !important;">
                <i class="fal fa-building mr-2" style="font-size: 12px; color: #9ca3af;"></i>
                <span id="current-branch-name" class="font-weight-bold mr-2" style="font-size: 11px; color: #374151;">Loading...</span>
                <i class="fal fa-chevron-down" style="font-size: 10px; color: #9ca3af;"></i>
            </button>
            <div class="dropdown-menu dropdown-menu-right shadow-lg border-0 mt-2" aria-labelledby="branchDropdown" id="branch-list" style="border-radius: 12px; min-width: 200px; padding: 8px;">
                <!-- Branches will be populated here -->
            </div>
        </div>
    </div>
</div>

<style>
    .menu-toggle-icon:hover {
        color: #2563eb !important;
        transform: scale(1.1);
        transition: all 0.2s ease;
    }
    .branch-item {
        font-size: 12px;
        padding: 8px 12px;
        border-radius: 8px;
        color: #4b5563;
        transition: all 0.2s;
        cursor: pointer;
        font-weight: 500;
    }
    .branch-item:hover {
        background-color: #f3f4f6;
        color: #2563eb;
    }
    .branch-item.active {
        background-color: #eff6ff;
        color: #2563eb;
        font-weight: 600;
    }
    @media (max-width: 768px) {
        .page-header-title {
            max-width: 12ch;
            font-size: 13.5px !important;
        }
    }
</style>

<script>
    $(document).ready(function(){
        const branchList = $("#branch-list");
        const currentBranchName = $("#current-branch-name");
        
        function adjustHeaderForMobile() {
            const titleSpan = $(".page-header-title");
            const originalText = titleSpan.attr("data-original-title") || titleSpan.text().trim();
            
            if (!titleSpan.attr("data-original-title")) {
                titleSpan.attr("data-original-title", originalText);
            }
            
            if (window.innerWidth <= 768) {
                if (originalText.length > 11) {
                    titleSpan.text(originalText.slice(0, 11) + "...");
                } else {
                    titleSpan.text(originalText);
                }
            } else {
                titleSpan.text(originalText);
            }
        }
        
        adjustHeaderForMobile();
        $(window).on("resize", adjustHeaderForMobile);

        function loadBranchData() {
            const branchesPromise = $.getJSON("../controllers/settingoperations.php", {getbranches: true});
            const userPromise = $.getJSON("../controllers/useroperations.php", {getloggedinuserdetails: true});

            Promise.all([branchesPromise, userPromise]).then(([branches, user]) => {
                let items = "";
                branches.forEach(branch => {
                    const isActive = user.status == "success" && user.branchid == branch.branchid;
                    if(isActive) {
                        currentBranchName.text(branch.branchname);
                    }
                    items += `<div class="branch-item ${isActive ? 'active' : ''}" data-id="${branch.branchid}">${branch.branchname}</div>`;
                });
                branchList.html(items);

                // Handle branch selection
                $(".branch-item").on("click", function(){
                    const branchId = $(this).data("id");
                    $.post("../controllers/settingoperations.php", {
                        update_session_branch: true, 
                        branchid: branchId
                    }, function(response){
                        if(response.trim() === "success"){
                            location.reload();
                        }
                    });
                });
            }).catch(err => {
                console.error("Error loading branch data:", err);
            });
        }

        loadBranchData();
    });
</script>
