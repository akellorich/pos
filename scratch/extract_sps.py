import re

sps_to_find = [
    'spgetglstatement',
    'spgetbalancesheet',
    'spgetprofitandlossaccount',
    'spgetprofitandlossaccountdetails',
    'spgetprofitandlossaccountheader',
    'spgettrialbalance',
    'spgetaccountspayableaginganalysis',
    'spgetaccountsreceivableaginganalysis',
    'spgetposstockbalanceasatdate',
    'spgetdiscountreport',
    'spgetprofitabilityreport',
    'sp_gettransferreportbyitems'
]

with open(r'c:\xampp\htdocs\pos\migrations\pos_autoclassic.sql', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

output_blocks = []

for sp in sps_to_find:
    # Look for the drop statement
    drop_pattern = r'(/\*!\d+\s+DROP\s+PROCEDURE\s+IF\s+EXISTS\s+`?' + re.escape(sp) + r'`?\s*\*/\s*;)'
    drop_match = re.search(drop_pattern, text, re.IGNORECASE)
    if not drop_match:
        print(f"Could not find DROP for {sp}")
        continue
    
    start_idx = drop_match.start()
    
    # Look for the ending pattern: */$$ followed by DELIMITER ;
    # Or just DELIMITER ;
    end_pattern = r'(\*/\s*\$\$\s*DELIMITER\s+;)'
    end_match = re.search(end_pattern, text[start_idx:], re.IGNORECASE)
    if not end_match:
        print(f"Could not find end for {sp}")
        continue
        
    end_idx = start_idx + end_match.end()
    block = text[start_idx:end_idx]
    
    # Let's clean the block to fit standard SQL format
    # 1. Replace DROP comment wrapper:
    # /*!50003 DROP PROCEDURE IF EXISTS  `spgetglstatement` */; -> DROP PROCEDURE IF EXISTS `spgetglstatement`$$
    clean_block = re.sub(
        r'/\*!\d+\s+DROP\s+PROCEDURE\s+IF\s+EXISTS\s+(.*?)\s*\*/\s*;',
        r'DROP PROCEDURE IF EXISTS \1$$',
        block,
        flags=re.IGNORECASE
    )
    
    # Remove DELIMITER $$ and DELIMITER ; lines inside the block
    clean_block = re.sub(r'DELIMITER\s+\$\$', '', clean_block, flags=re.IGNORECASE)
    clean_block = re.sub(r'DELIMITER\s+;', '', clean_block, flags=re.IGNORECASE)
    
    # Clean the CREATE DEFINER line:
    # /*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetglstatement`($branchid INT, ...
    # We want to replace the starting /*!50003 and the ending */$$
    # Let's first search for /*!50003 CREATE and strip it
    clean_block = re.sub(r'/\*!\d+\s+CREATE', 'CREATE', clean_block, flags=re.IGNORECASE)
    
    # And at the end, replace */$$ or similar
    # e.g. END */$$ -> END$$
    # Let's search for */$$
    clean_block = re.sub(r'\*/\s*\$\$', '$$', clean_block)
    
    # Strip extra whitespace and empty lines
    clean_block = clean_block.strip()
    
    output_blocks.append(f"-- ---------------------------------------------------\n-- PROCEDURE: {sp}\n-- ---------------------------------------------------\n{clean_block}\n")
    print(f"Processed {sp}")

# Join all blocks with DELIMITER $$ at the beginning and DELIMITER ; at the end
final_sql = "DELIMITER $$\n\n" + "\n".join(output_blocks) + "\nDELIMITER ;\n"

with open(r'c:\xampp\htdocs\pos\migrations\extracted_recent_sps.sql', 'w', encoding='utf-8') as out_f:
    out_f.write(final_sql)

print("Saved to migrations/extracted_recent_sps.sql")
