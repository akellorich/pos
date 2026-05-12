$(document).ready(()=>{
    testprinterbutton=$("#testprinter")
    const homebutton=$("#home")

    testprinterbutton.on("click",()=>{
            printJS({ 
                printable: 'printtest', 
                type: 'html', 
                width:219,
                css:"receipt58mm.css"
            })
        }
    )

    homebutton.click(()=>{
        window.history.back()
    })
})