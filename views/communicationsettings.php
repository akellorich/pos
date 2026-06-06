<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Communication Settings </title>
    <style>
      /* Elevated custom styles for premium look */
      .containergroup.card {
          border: none;
          border-radius: 12px;
          box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
          background: #ffffff;
          overflow: hidden;
          transition: transform 0.2s ease, box-shadow 0.2s ease;
      }
      
      .containergroup .card-header {
          background: linear-gradient(135deg, #2b5c8f, #4a75a0);
          border-bottom: none;
          display: flex;
          align-items: center;
          height: 60px !important;
          padding: 15px 25px !important;
      }
      
      .containergroup .card-header h5 {
          margin-bottom: 0;
          font-size: 1.2rem;
          color: #ffffff;
          font-weight: 600;
          letter-spacing: 0.5px;
      }
      
      /* Premium Tab Navigation */
      .nav-tabs {
          border-bottom: 2px solid #ebf2f7;
          margin-bottom: 25px;
      }
      
      .nav-tabs .nav-link {
          border: none;
          color: #6c757d;
          font-weight: 600;
          font-size: 0.95rem;
          padding: 12px 24px;
          position: relative;
          transition: color 0.3s ease;
      }
      
      .nav-tabs .nav-link:hover {
          color: #2b5c8f;
          background: transparent;
      }
      
      .nav-tabs .nav-link.active {
          color: #2b5c8f;
          background: transparent;
          border: none;
      }
      
      .nav-tabs .nav-link.active::after {
          content: '';
          position: absolute;
          bottom: -2px;
          left: 0;
          width: 100%;
          height: 3px;
          background-color: #2b5c8f;
          border-radius: 3px;
      }
      
      /* Form Layout Customization */
      .form-group label {
          font-weight: 600;
          color: #495057;
          font-size: 0.85rem;
          margin-bottom: 6px;
      }
      
      .form-control-sm {
          border-radius: 6px;
          border: 1px solid #ced4da;
          padding: 10px 12px;
          height: auto !important;
          font-size: 0.88rem;
          transition: border-color 0.2s ease, box-shadow 0.2s ease;
      }
      
      .form-control-sm:focus {
          border-color: #2b5c8f;
          box-shadow: 0 0 0 3px rgba(43, 92, 143, 0.15);
      }
      
      /* Button styles */
      .btn-sm-action {
          padding: 8px 20px;
          font-size: 0.88rem;
          font-weight: 600;
          border-radius: 6px;
          transition: all 0.2s ease;
      }
      
      .btn-primary-action {
          background-color: #2b5c8f;
          border-color: #2b5c8f;
          color: #ffffff;
      }
      
      .btn-primary-action:hover {
          background-color: #20456c;
          border-color: #20456c;
          color: #ffffff;
          box-shadow: 0 4px 12px rgba(43, 92, 143, 0.25);
      }
      
      .btn-test-action {
          background-color: #f8f9fa;
          border: 1px solid #ced4da;
          color: #495057;
      }
      
      .btn-test-action:hover {
          background-color: #e9ecef;
          border-color: #adb5bd;
          color: #212529;
      }
      
      .test-panel {
          background-color: #f8f9fa;
          border-radius: 8px;
          border-left: 4px solid #2b5c8f;
          padding: 20px;
          margin-top: 25px;
      }
      
      .test-panel-title {
          font-size: 0.9rem;
          font-weight: 700;
          color: #2b5c8f;
          margin-bottom: 12px;
          text-transform: uppercase;
          letter-spacing: 0.5px;
      }
    </style>
   </head>
 <body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Communication Settings"; require_once("topbar.php"); ?>
        <div class="container-fluid py-4">
            <div class="card containergroup">
                <div class="card-header">
                    <h5><i class="fal fa-comments fa-fw mr-2"></i>Communication Configuration</h5>
                </div>
                <div class="card-body p-4">
                    <div id="notifications"></div>
                    
                    <!-- Tabs -->
                    <ul class="nav nav-tabs" id="commTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="email-tab" data-toggle="tab" href="#email" role="tab"><i class="fal fa-envelope fa-fw mr-2"></i>Email Settings</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="sms-tab" data-toggle="tab" href="#sms" role="tab"><i class="fal fa-sms fa-fw mr-2"></i>SMS Settings</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="whatsapp-tab" data-toggle="tab" href="#whatsapp" role="tab"><i class="fab fa-whatsapp fa-fw mr-2"></i>WhatsApp Settings</a>
                        </li>
                    </ul>
                    
                    <!-- Tab Content -->
                    <div class="tab-content" id="commTabsContent">
                        
                        <!-- Email Tab -->
                        <div class="tab-pane fade show active" id="email" role="tabpanel">
                            <form id="emailForm">
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="emailaddress">Sender Email Address</label>
                                        <input type="email" name="emailaddress" id="emailaddress" class="form-control form-control-sm" required placeholder="e.g. system@salesflow.com">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="password">Email Password</label>
                                        <input type="password" name="password" id="password" class="form-control form-control-sm" required placeholder="••••••••••••">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="smtpserver">SMTP Server Host</label>
                                        <input type="text" name="smtpserver" id="smtpserver" class="form-control form-control-sm" required placeholder="e.g. smtp.gmail.com">
                                    </div>
                                    <div class="col-md-3 form-group">
                                        <label for="smtpport">SMTP Port</label>
                                        <input type="number" name="smtpport" id="smtpport" class="form-control form-control-sm" required placeholder="e.g. 587">
                                    </div>
                                    <div class="col-md-3 form-group">
                                        <label for="usessl">Security protocol</label>
                                        <select name="usessl" id="usessl" class="form-control form-control-sm">
                                            <option value="0">TLS (Port 587 / STARTTLS)</option>
                                            <option value="1">SSL (Port 465)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mt-3">
                                    <button type="submit" class="btn btn-sm btn-primary-action btn-sm-action"><i class="fal fa-save mr-2"></i>Save Email Settings</button>
                                </div>
                            </form>
                            
                            <!-- Test Panel -->
                            <div class="test-panel">
                                <div class="test-panel-title"><i class="fal fa-vial mr-2"></i>Test Email Configuration</div>
                                <div class="row align-items-end">
                                    <div class="col-md-8 form-group mb-0">
                                        <label for="testEmailRecipient">Recipient Email Address</label>
                                        <input type="email" id="testEmailRecipient" class="form-control form-control-sm" placeholder="Type a destination email to test">
                                    </div>
                                    <div class="col-md-4 mb-0">
                                        <button type="button" id="btnTestEmail" class="btn btn-block btn-test-action btn-sm-action"><i class="fal fa-paper-plane mr-2"></i>Send Test Email</button>
                                    </div>
                                </div>
                                <div id="emailTestFeedback" class="mt-3"></div>
                            </div>
                        </div>
                        
                        <!-- SMS Tab -->
                        <div class="tab-pane fade" id="sms" role="tabpanel">
                            <form id="smsForm">
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="sms_apikey">API Key / Access Token</label>
                                        <input type="text" name="apikey" id="sms_apikey" class="form-control form-control-sm" required placeholder="Your SMS API key">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="sms_senderid">Sender ID</label>
                                        <input type="text" name="senderid" id="sms_senderid" class="form-control form-control-sm" required placeholder="e.g. BRANDNAME">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="sms_partnerid">Partner ID / Client ID</label>
                                        <input type="text" name="partnerid" id="sms_partnerid" class="form-control form-control-sm" placeholder="Required by some SMS APIs">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="sms_url">Gateway API URL</label>
                                        <input type="url" name="url" id="sms_url" class="form-control form-control-sm" required placeholder="e.g. https://api.gateway.com/SendSMS">
                                    </div>
                                </div>
                                <div class="mt-3">
                                    <button type="submit" class="btn btn-sm btn-primary-action btn-sm-action"><i class="fal fa-save mr-2"></i>Save SMS Settings</button>
                                </div>
                            </form>
                            
                            <!-- Test Panel -->
                            <div class="test-panel">
                                <div class="test-panel-title"><i class="fal fa-vial mr-2"></i>Test SMS Configuration</div>
                                <div class="row align-items-end">
                                    <div class="col-md-8 form-group mb-0">
                                        <label for="testSmsRecipient">Recipient Phone Number (with Country Code)</label>
                                        <input type="text" id="testSmsRecipient" class="form-control form-control-sm" placeholder="e.g. 254720000000">
                                    </div>
                                    <div class="col-md-4 mb-0">
                                        <button type="button" id="btnTestSms" class="btn btn-block btn-test-action btn-sm-action"><i class="fal fa-comment-alt mr-2"></i>Send Test SMS</button>
                                    </div>
                                </div>
                                <div id="smsTestFeedback" class="mt-3"></div>
                            </div>
                        </div>
                        
                        <!-- WhatsApp Tab -->
                        <div class="tab-pane fade" id="whatsapp" role="tabpanel">
                            <form id="whatsappForm">
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="wa_apikey">Permanent Access Token (API Key)</label>
                                        <input type="text" name="apikey" id="wa_apikey" class="form-control form-control-sm" required placeholder="WhatsApp Cloud API bearer token">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="wa_phone_number_id">Phone Number ID</label>
                                        <input type="text" name="phone_number_id" id="wa_phone_number_id" class="form-control form-control-sm" required placeholder="Facebook App Phone Number ID">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <label for="wa_url">Endpoint URL (Optional - Default Meta Cloud URL will be used if blank)</label>
                                        <input type="url" name="url" id="wa_url" class="form-control form-control-sm" placeholder="e.g. https://graph.facebook.com/v16.0/YOUR_PHONE_NUMBER_ID/messages">
                                    </div>
                                </div>
                                <div class="mt-3">
                                    <button type="submit" class="btn btn-sm btn-primary-action btn-sm-action"><i class="fal fa-save mr-2"></i>Save WhatsApp Settings</button>
                                </div>
                            </form>
                            
                            <!-- Test Panel -->
                            <div class="test-panel">
                                <div class="test-panel-title"><i class="fal fa-vial mr-2"></i>Test WhatsApp Configuration</div>
                                <div class="row align-items-end">
                                    <div class="col-md-8 form-group mb-0">
                                        <label for="testWaRecipient">Recipient Phone Number (with Country Code)</label>
                                        <input type="text" id="testWaRecipient" class="form-control form-control-sm" placeholder="e.g. 254720000000">
                                    </div>
                                    <div class="col-md-4 mb-0">
                                        <button type="button" id="btnTestWa" class="btn btn-block btn-test-action btn-sm-action"><i class="fab fa-whatsapp mr-2"></i>Send Test Message</button>
                                    </div>
                                </div>
                                <div id="waTestFeedback" class="mt-3"></div>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </section>
 </body>
 <?php require_once("footer.txt") ?>
 <script>
    $(document).ready(function(){
        
        // Fetch current settings on load
        function loadSettings() {
            $.getJSON('../controllers/communicationsettingsoperations.php', { getcommsettings: true }, function(data){
                if (data.email) {
                    $('#emailaddress').val(data.email.emailaddress);
                    $('#password').val(data.email.password);
                    $('#smtpserver').val(data.email.smtpserver);
                    $('#smtpport').val(data.email.smtpport);
                    $('#usessl').val(data.email.usessl);
                }
                if (data.sms) {
                    $('#sms_apikey').val(data.sms.apikey);
                    $('#sms_senderid').val(data.sms.senderid);
                    $('#sms_partnerid').val(data.sms.partnerid);
                    $('#sms_url').val(data.sms.url);
                }
                if (data.whatsapp) {
                    $('#wa_apikey').val(data.whatsapp.apikey);
                    $('#wa_phone_number_id').val(data.whatsapp.phone_number_id);
                    $('#wa_url').val(data.whatsapp.url);
                }
            });
        }
        loadSettings();
        
        // Save Email Settings
        $('#emailForm').on('submit', function(e){
            e.preventDefault();
            var formData = $(this).serialize() + '&savecommsettings=true&type=email';
            $.post('../controllers/communicationsettingsoperations.php', formData, function(res){
                if ($.trim(res) == 'success') {
                    $('#notifications').html(showAlert('success', 'Email configuration saved successfully!'));
                    loadSettings();
                } else {
                    $('#notifications').html(showAlert('danger', 'Error saving Email settings: ' + res));
                }
                window.scrollTo(0, 0);
            });
        });
        
        // Save SMS Settings
        $('#smsForm').on('submit', function(e){
            e.preventDefault();
            var formData = $(this).serialize() + '&savecommsettings=true&type=sms';
            $.post('../controllers/communicationsettingsoperations.php', formData, function(res){
                if ($.trim(res) == 'success') {
                    $('#notifications').html(showAlert('success', 'SMS configuration saved successfully!'));
                    loadSettings();
                } else {
                    $('#notifications').html(showAlert('danger', 'Error saving SMS settings: ' + res));
                }
                window.scrollTo(0, 0);
            });
        });
        
        // Save WhatsApp Settings
        $('#whatsappForm').on('submit', function(e){
            e.preventDefault();
            var formData = $(this).serialize() + '&savecommsettings=true&type=whatsapp';
            $.post('../controllers/communicationsettingsoperations.php', formData, function(res){
                if ($.trim(res) == 'success') {
                    $('#notifications').html(showAlert('success', 'WhatsApp configuration saved successfully!'));
                    loadSettings();
                } else {
                    $('#notifications').html(showAlert('danger', 'Error saving WhatsApp settings: ' + res));
                }
                window.scrollTo(0, 0);
            });
        });
        
        // Test Email Settings
        $('#btnTestEmail').on('click', function(){
            var recipient = $('#testEmailRecipient').val();
            if (recipient == '') {
                $('#emailTestFeedback').html(showAlert('warning', 'Please enter a recipient email address!'));
                return;
            }
            $('#emailTestFeedback').html(showAlert('processing', 'Sending test email, please wait...', 1));
            
            var params = {
                testcommsettings: true,
                type: 'email',
                recipient: recipient,
                emailaddress: $('#emailaddress').val(),
                password: $('#password').val(),
                smtpserver: $('#smtpserver').val(),
                smtpport: $('#smtpport').val(),
                usessl: $('#usessl').val()
            };
            
            $.post('../controllers/communicationsettingsoperations.php', params, function(res){
                if ($.trim(res) == 'success') {
                    $('#emailTestFeedback').html(showAlert('success', 'Test email dispatched successfully! Please check the inbox of ' + recipient));
                } else {
                    $('#emailTestFeedback').html(showAlert('danger', 'Email test connection failed: ' + res));
                }
            });
        });
        
        // Test SMS Settings
        $('#btnTestSms').on('click', function(){
            var recipient = $('#testSmsRecipient').val();
            if (recipient == '') {
                $('#smsTestFeedback').html(showAlert('warning', 'Please enter a recipient phone number!'));
                return;
            }
            $('#smsTestFeedback').html(showAlert('processing', 'Sending test SMS via API, please wait...', 1));
            
            var params = {
                testcommsettings: true,
                type: 'sms',
                recipient: recipient,
                apikey: $('#sms_apikey').val(),
                senderid: $('#sms_senderid').val(),
                partnerid: $('#sms_partnerid').val(),
                url: $('#sms_url').val()
            };
            
            $.post('../controllers/communicationsettingsoperations.php', params, function(res){
                if (res.indexOf('success') !== -1) {
                    $('#smsTestFeedback').html(showAlert('success', 'Test SMS successfully sent to ' + recipient + '! API returned: ' + res));
                } else {
                    $('#smsTestFeedback').html(showAlert('danger', 'SMS API test connection failed: ' + res));
                }
            });
        });
        
        // Test WhatsApp Settings
        $('#btnTestWa').on('click', function(){
            var recipient = $('#testWaRecipient').val();
            if (recipient == '') {
                $('#waTestFeedback').html(showAlert('warning', 'Please enter a recipient phone number!'));
                return;
            }
            $('#waTestFeedback').html(showAlert('processing', 'Sending test WhatsApp message via API, please wait...', 1));
            
            var params = {
                testcommsettings: true,
                type: 'whatsapp',
                recipient: recipient,
                apikey: $('#wa_apikey').val(),
                phone_number_id: $('#wa_phone_number_id').val(),
                url: $('#wa_url').val()
            };
            
            $.post('../controllers/communicationsettingsoperations.php', params, function(res){
                if (res.indexOf('success') !== -1) {
                    $('#waTestFeedback').html(showAlert('success', 'Test WhatsApp message sent successfully to ' + recipient + '! Meta returned: ' + res));
                } else {
                    $('#waTestFeedback').html(showAlert('danger', 'WhatsApp API test connection failed: ' + res));
                }
            });
        });
        
    });
 </script>
</html>
