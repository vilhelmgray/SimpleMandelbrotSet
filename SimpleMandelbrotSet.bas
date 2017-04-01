' Copyright (c) 2017, William Breathitt Gray
' All rights reserved.
' 
' Redistribution and use in source and binary forms, with or without modification,
' are permitted provided that the following conditions are met:
' 
'   Redistributions of source code must retain the above copyright notice, this
'   list of conditions and the following disclaimer.
' 
'   Redistributions in binary form must reproduce the above copyright notice, this
'   list of conditions and the following disclaimer in the documentation and/or
'   other materials provided with the distribution.
' 
' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
' ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
' WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
' ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
' (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
' LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
' ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
' (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
' SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Const scrn_width As Integer = 500
Const scrn_height As Integer = 500
Const scrn_slide As Integer = scrn_width / 10
Dim Shared zoom As Double = 4
Dim Shared zoom_step As Double
Dim Shared offset_x As Double = 0
Dim Shared offset_y As Double = 0
Dim Shared res_step As Integer = &H10000

ScreenRes scrn_width, scrn_height, 16

Sub drawMandelbrotPoint(ByVal x As Double, ByVal y As Double)
        Dim r As Double = zoom_step*x - zoom/2 + offset_x
        Dim i As Double = zoom_step*y - zoom/2 + offset_y

        Dim z_x As Double = r
        Dim z_y As Double = i
        For iter As Integer = &H1 to &HFFFFFF Step res_step
                Dim z_x_next As Double = z_x*z_x - z_y*z_y + r
                z_y = 2*z_x*z_y + i
                z_x = z_x_next

                If (z_x >= 2 Or z_y >= 2) Then
                        Pset (x, y), iter
                        Exit Sub
                End If
        Next iter
End Sub

Sub drawMandelbrotSet
        For x As Integer = 0 to scrn_width-1
                For y As Integer = 0 to scrn_height-1
                        drawMandelbrotPoint(x, y)
                Next y
        Next x
End Sub

zoom_step = zoom / scrn_width

Dim k As String
Do
        drawMandelbrotSet

	Print "Offset: (" & offset_x & "," & offset_y &")"
	Print "Zoom: " & zoom
	Print "Resolution step: " & res_step

        Do
                k = InKey$
                Select Case k
                        Case "w"
                                offset_y -= zoom_step * scrn_slide
                                Exit Do
                        Case "a"
                                offset_x -= zoom_step * scrn_slide
                                Exit Do
                        Case "s"
                                offset_y += zoom_step * scrn_slide
                                Exit Do
                        Case "d"
                                offset_x += zoom_step * scrn_slide
                                Exit Do
                        Case "q"
                                zoom *= 2
                                zoom_step = zoom / scrn_width
                                Exit Do
                        Case "e"
                                zoom /= 2
                                zoom_step = zoom / scrn_width
                                Exit Do
			Case "z"
				res_step *= 2
                                Exit Do
			Case "c"
				If res_step > 1 Then
					res_step /= 2
				End If
                                Exit Do
                        Case "x"
                                End
                End Select
        Loop 

        Cls
Loop

End
