<?php

import('classes.lib.fpdf.fpdf');

class PDF extends FPDF {
	function Header()
	{
		$this->SetFont('Times','B',14);
		
                // Logo
                $this->Image("public/site/images/mainlogo.png", 85, 5, 40);
		$this->Ln(20);
                
                // First line title
                $title = "Lao People's Democratic Republic";
		$w = $this->GetStringWidth($title);
		$this->SetX(105-($w/2));
		$this->Cell($w,6,$title,0,1,'C');

                // Second line title
		$this->SetFont('Times','',14);
                $title = "Peace Independence Democracy Unity Prosperity";
		$w = $this->GetStringWidth($title);
		$this->SetX(105-($w/2));
		$this->Cell($w,6,$title,0,1,'C');

                // Third line title
                $title = "===  000  ===";
		$w = $this->GetStringWidth($title);
		$this->SetX(105-($w/2));
		$this->Cell($w,6,$title,0,1,'C');

                // Line break
		$this->Ln(5);
	}

	function Footer()
	{
		// Position at 1.5 cm from bottom
		$this->SetY(-15);
		// Arial italic 8
		$this->SetFont('Times','I',8);
		// Text color in gray
		$this->SetTextColor(128);
		// Page number
		$this->Cell(0,10,'Page '.$this->PageNo(),0,0,'C');
	}

	function ChapterTitle($label, $style = 'B')
	{
		$this->SetFont('Times',$style,16);
		$this->MultiCell(0,6,$label,0,'C');
		$this->Ln();
	}

	function ChapterItemKeyVal($key, $val, $style = 'B')
	{
		$this->SetFont('Times', $style,12);
		$this->Cell(0,6,$key,0,1,'L',false);
		$this->SetFont('Times','',12); 
		$this->MultiCell(0,5,$val);
		// Line break
		$this->Ln();
	}
	
	function ChapterItemKey($key, $style = 'B')
	{
		$this->SetFont('Times', $style,12);
		$this->Cell(0,6,$key,0,1,'L',false);
		$this->SetFont('Times','',12); 		
		// Line break
		$this->Ln();
	}
	
	function ChapterItemVal($val, $style = '')
	{
		$this->SetFont('Times',$style,12); 
		$this->MultiCell(0,5,$val);
		// Line break
		$this->Ln();
	}

}

?>
