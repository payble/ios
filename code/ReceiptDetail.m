//
//  ReceiptDetail.m
//  kentApp
//
//  Created by N@kuL on 10/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "ReceiptDetail.h"
#import "DSActivityView.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "QAUtils.h"

@interface ReceiptDetail ()

@end

@implementation ReceiptDetail
@synthesize dicRestaurentDetail2,arrForCArdList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    //[receiptView setFrame:CGRectMake(receiptView.frame.origin.x, receiptView.frame.origin.y, receiptView.frame.size.width, receiptView.frame.size.height-btnPAy.frame.size.height)];
    
    viewReceiptBackWithPay.layer.cornerRadius=7.0f;
    viewReceiptBackWithPay.clipsToBounds=YES;
    
    viewReceiptBackWithPayProcessed.layer.cornerRadius=5.0f;
    viewReceiptBackWithPayProcessed.clipsToBounds=YES;
    
    txtfTip.layer.borderColor=[UIColor blueColor].CGColor;
    txtfTipProcessed.layer.borderColor=[UIColor blueColor].CGColor;

    
     [self setReceiptValues];
    
    
    //[self ckeckPayMentMode];
    
    strType=@"getAllCards";
    
    if (IDIOM == IPAD){
        
        
        lblTitle.frame          =   CGRectMake(lblTitle.frame.origin.x-50, lblTitle.frame.origin.y, lblTitle.frame.size.width+100, lblTitle.frame.size.height);
        
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font           =   [UIFont fontWithName:FONT_TITLE size:22];
        
        lblCompanyNmae.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPhone.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUserName.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPayment.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblSubtotal.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblSubtotalPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTax.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTaxPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTotal.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTotalPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDeliveryLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDeliveryValue.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblkentFeePoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblCompanyNmaeProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPhoneProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUserNameProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPaymentProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblSubtotalProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTaxProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTotalProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDeliveryLabelProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDeliveryValueProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblTipPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTipProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblSubtotalProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTaxProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTotalProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblkentFeeProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblUCmpny.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUPhone.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUAddress.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUName.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUPayments.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUSummary.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUSubtotal.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUTax.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUFee.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUTip.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblUTotal.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblDCmpny.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDPhone.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDAddress.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDName.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDPayments.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDSummary.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDSubtotal.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDTax.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDTip.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDTotal.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblInfo.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        btnPAy.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        textVAddress.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtfTip.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        textVAddressProcessed.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtfTipProcessed.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblSubtotal.frame  =   CGRectMake(lblSubtotal.frame.origin.x-5, lblSubtotal.frame.origin.y, lblSubtotal.frame.size.width, lblSubtotal.frame.size.height);

        lblTax.frame  =   CGRectMake(lblTax.frame.origin.x-5, lblTax.frame.origin.y, lblTax.frame.size.width, lblTax.frame.size.height);

        lblTotal.frame  =   CGRectMake(lblTotal.frame.origin.x-5, lblTotal.frame.origin.y, lblTotal.frame.size.width, lblTotal.frame.size.height);

        lblDeliveryValue.frame  =   CGRectMake(lblDeliveryValue.frame.origin.x-5, lblDeliveryValue.frame.origin.y, lblDeliveryValue.frame.size.width, lblDeliveryValue.frame.size.height);

        txtfTip.frame   =   CGRectMake(txtfTip.frame.origin.x-5, txtfTip.frame.origin.y, txtfTip.frame.size.width, txtfTip.frame.size.height);
        
        
        lblSubtotalProcessed.frame   =   CGRectMake(lblSubtotalProcessed.frame.origin.x-5, lblSubtotalProcessed.frame.origin.y, lblSubtotalProcessed.frame.size.width, lblSubtotalProcessed.frame.size.height);
        
        lblTaxProcessed.frame   =   CGRectMake(lblTaxProcessed.frame.origin.x-5, lblTaxProcessed.frame.origin.y, lblTaxProcessed.frame.size.width, lblTaxProcessed.frame.size.height);
        
        lblTotalProcessed.frame   =   CGRectMake(lblTotalProcessed.frame.origin.x-5, lblTotalProcessed.frame.origin.y, lblTotalProcessed.frame.size.width, lblTotalProcessed.frame.size.height);
        
        lblDeliveryValueProcessed.frame   =   CGRectMake(lblDeliveryValueProcessed.frame.origin.x-5, lblDeliveryValueProcessed.frame.origin.y, lblDeliveryValueProcessed.frame.size.width, lblDeliveryValueProcessed.frame.size.height);
        
        txtfTipProcessed.frame   =   CGRectMake(txtfTipProcessed.frame.origin.x-5, txtfTipProcessed.frame.origin.y, txtfTipProcessed.frame.size.width, txtfTipProcessed.frame.size.height);

    }else{
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font           =   [UIFont fontWithName:FONT_TITLE size:14];
        
        lblCompanyNmae.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPhone.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUserName.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPayment.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblSubtotal.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblSubtotalPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTax.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTaxPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTotal.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTotalPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDeliveryLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDeliveryValue.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblkentFeePoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblCompanyNmaeProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPhoneProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUserNameProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPaymentProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblSubtotalProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTaxProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTotalProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDeliveryLabelProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDeliveryValueProcessed.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblTipPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTipProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblSubtotalProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTaxProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTotalProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblkentFeeProcessedPoint.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblUCmpny.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUPhone.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUAddress.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUName.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUPayments.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUSummary.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUSubtotal.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUTax.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUFee.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUTip.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblUTotal.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblDCmpny.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDPhone.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDAddress.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDName.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDPayments.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDSummary.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDSubtotal.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDTax.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDTip.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDTotal.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblInfo.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        btnPAy.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        textVAddress.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtfTip.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        textVAddressProcessed.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtfTipProcessed.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
    }
    
    txtfTip.keyboardType    =   UIKeyboardTypeNumberPad;
    txtfTip.delegate        =   self;
    
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
   

    if ([[dicRestaurentDetail2 objectForKey:@"status"] isEqualToString:@"Processed"]) //for processed receipt
    {
//        lblTipProcessedPoint.hidden=YES;
//        txtfTipProcessed.text=[txtfTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
//        
//        [self keyboardShow:viewReceiptBackWithPayProcessed];
    }
    else
    {
        lblTipPoint.hidden=YES;
        txtfTip.text=[txtfTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        [self keyboardShow:viewReceiptBackWithPay];
        
        
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    if ([[dicRestaurentDetail2 objectForKey:@"status"] isEqualToString:@"Processed"]) //for processed receipt
    {
//       lblTipProcessedPoint.hidden=NO;
//        
//        txtfTipProcessed.text=[txtfTipProcessed.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//
//        
//        NSArray *arrtip=[txtfTipProcessed.text componentsSeparatedByString:@"."];
//        if (arrtip.count==2)
//        {
//            txtfTipProcessed.text=[NSString stringWithFormat:@"$ %@",[arrtip objectAtIndex:0]];
//            lblTipProcessedPoint.text=[NSString stringWithFormat:@"%@",[arrtip objectAtIndex:1]];
//        }
//        else
//        {
//            txtfTipProcessed.text=[NSString stringWithFormat:@"$ %@",[arrtip objectAtIndex:0]];
//            lblTipProcessedPoint.text=@"00";
//            
//        }
//        
//        [self keyboardHide:viewReceiptBackWithPayProcessed];
//        [txtfTipProcessed resignFirstResponder];
    }
    else
    {
         lblTipPoint.hidden=NO;
        
        txtfTip.text=[txtfTip.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSArray *arrtip=[txtfTip.text componentsSeparatedByString:@"."];
        if (arrtip.count==2)
        {
            txtfTip.text=[NSString stringWithFormat:@"$ %@",[arrtip objectAtIndex:0]];
            lblTipPoint.text=[NSString stringWithFormat:@"%@",[arrtip objectAtIndex:1]];
        }
        else
        {
            txtfTip.text=[NSString stringWithFormat:@"$ %@",[arrtip objectAtIndex:0]];
            lblTipPoint.text=@"00";
            
        }
        
//        NSString *strTipFromText=[[txtfTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        float tipEdited= [[[txtfTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  floatValue];
        
         float newTotal=[[dicRestaurentDetail2 objectForKey:@"invoice_amount"]floatValue]-[[dicRestaurentDetail2 objectForKey:@"tip"]floatValue]+tipEdited;
        
        
        NSArray *arrTotal=[[NSString stringWithFormat:@"%.2f",newTotal] componentsSeparatedByString:@"."];
        if (arrTotal.count==2)
        {
            lblTotal.text=[NSString stringWithFormat:@"$ %@",[arrTotal objectAtIndex:0]];
            lblTotalPoint.text=[NSString stringWithFormat:@"%@",[arrTotal objectAtIndex:1]];
        }
        else
        {
            lblTotal.text=[NSString stringWithFormat:@"$ %@",[arrTotal objectAtIndex:0]];
            lblTotalPoint.text=@"00";
            
        }
        
        
//        if (tipEdited <[[dicRestaurentDetail2 objectForKey:@"tip"]floatValue])
//        {
//            float newTotal=[[dicRestaurentDetail2 objectForKey:@"invoice_amount"]floatValue]-tipEdited;
//        }
//        else if (tipEdited >[[dicRestaurentDetail2 objectForKey:@"tip"]floatValue])
//        {
//            float newTotal=[[dicRestaurentDetail2 objectForKey:@"invoice_amount"]floatValue]-tipEdited;
//
//        }
//        
        
        
        [self keyboardHide:viewReceiptBackWithPay];
        [txtfTip resignFirstResponder];
        
    }
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (![[dicRestaurentDetail2 objectForKey:@"status"] isEqualToString:@"Processed"]) //for processed receipt
//    {
        // allow backspace
        if (!string.length)
        {
            return YES;
        }
        
        // Prevent invalid character input, if keyboard is numberpad
        if (textField.keyboardType == UIKeyboardTypeNumberPad)
        {
            if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
            {
                // BasicAlert(@"", @"This field accepts only numeric entries.");
                return NO;
            }
        }
//    }
    
    return YES;
}

-(void)setReceiptValues
{
    if ([[dicRestaurentDetail2 objectForKey:@"status"] isEqualToString:@"Processed"]) //for processed receipt
    {
        viewReceiptBackWithPayProcessed.hidden=NO;
        viewReceiptBackWithPay.hidden=YES;
        
                
        int flag=0;
   /*     for (int i=0;i<[arrForCArdList count]; i++)
        {
            if ([[[arrForCArdList objectAtIndex:i]objectForKey:@"is_default"] isEqualToString:@"1"])
            {
                // arrForCardList=[outputCard objectAtIndex:i];
                flag=1;
                
                NSString *str=[NSString stringWithFormat:@"%@",[[arrForCArdList objectAtIndex:i ] objectForKey:@"cc_number"]];
                NSString *code = [str substringFromIndex: [str length] -4];
                
                lblPaymentProcessed.text=[NSString stringWithFormat:@"%@ *%@",[[arrForCArdList objectAtIndex:i ] objectForKey:@"cc_type"],code];
                
                break;
            }
        }
        
        */
        
        
        for (int i=0;i<[arrForCArdList count]; i++)
        {
            if ([[[arrForCArdList objectAtIndex:i]objectForKey:@"id"] isEqualToString:[dicRestaurentDetail2 objectForKey:@"user_card_id"]])
            {
                // arrForCardList=[outputCard objectAtIndex:i];
                flag=1;
                
                NSString *str=[NSString stringWithFormat:@"%@",[[arrForCArdList objectAtIndex:i ] objectForKey:@"cc_number"]];
                NSString *code = [str substringFromIndex: [str length] -4];
                
                lblPaymentProcessed.text=[NSString stringWithFormat:@"%@ *%@",[[arrForCArdList objectAtIndex:i ] objectForKey:@"cc_type"],code];
                
                break;
            }
        }
        
        
        
        if (flag==0)
        {
            lblPaymentProcessed.text=nil;
        }
        
        
        lblCompanyNmaeProcessed.text=[dicRestaurentDetail2 objectForKey:@"restaurant_name"];
        lblPhoneProcessed.text=[dicRestaurentDetail2 objectForKey:@"phone_number"];
        //lblPaymentProcessed.text=[dicForCard objectForKey:@"cc_type"];
        
        
        NSArray *arrtax_amount=[[dicRestaurentDetail2 objectForKey:@"tax_amount"] componentsSeparatedByString:@"."];
        if (arrtax_amount.count==2)
        {
            lblTaxProcessed.text=[NSString stringWithFormat:@"$ %@",[arrtax_amount objectAtIndex:0]];
            lblTaxProcessedPoint.text=[NSString stringWithFormat:@"%@",[arrtax_amount objectAtIndex:1]];
        }
        else
        {
            lblTaxProcessed.text=[NSString stringWithFormat:@"$ %@",[arrtax_amount objectAtIndex:0]];
            lblTaxProcessedPoint.text=@"00";
            
        }
        
        
        
        NSArray *arrinvoicePrice=[[dicRestaurentDetail2 objectForKey:@"sub_total"] componentsSeparatedByString:@"."];
        if (arrinvoicePrice.count==2)
        {
            lblSubtotalProcessed.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
            lblSubtotalProcessedPoint.text=[NSString stringWithFormat:@"%@",[arrinvoicePrice objectAtIndex:1]];
        }
        else
        {
            lblSubtotalProcessed.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
            lblSubtotalProcessedPoint.text=@"00";
            
        }
        
        
        NSArray *arrinvoice_amount=[[dicRestaurentDetail2 objectForKey:@"invoice_amount"] componentsSeparatedByString:@"."];
        if (arrinvoice_amount.count==2)
        {
            lblTotalProcessed.text=[NSString stringWithFormat:@"$ %@",[arrinvoice_amount objectAtIndex:0]];
            lblTotalProcessedPoint.text=[NSString stringWithFormat:@"%@",[arrinvoice_amount objectAtIndex:1]];
        }
        else
        {
            lblTotalProcessed.text=[NSString stringWithFormat:@"$ %@",[arrinvoice_amount objectAtIndex:0]];
            lblTotalProcessedPoint.text=@"00";
            
        }
        
        NSArray *arrtip=[[dicRestaurentDetail2 objectForKey:@"tip"] componentsSeparatedByString:@"."];
        if (arrtip.count==2)
        {
            txtfTipProcessed.text=[NSString stringWithFormat:@"$ %@",[arrtip objectAtIndex:0]];
            lblTipProcessedPoint.text=[NSString stringWithFormat:@"%@",[arrtip objectAtIndex:1]];
        }
        else
        {
            txtfTipProcessed.text=[NSString stringWithFormat:@"$ %@",[arrtip objectAtIndex:0]];
            lblTipProcessedPoint.text=@"00";
            
        }
        
        
        NSArray *arrkent_fee=[[dicRestaurentDetail2 objectForKey:@"kent_fee"] componentsSeparatedByString:@"."];
        if (arrkent_fee.count==2)
        {
            lblDeliveryValueProcessed.text=[NSString stringWithFormat:@"$ %@",[arrkent_fee objectAtIndex:0]];
            lblkentFeeProcessedPoint.text=[NSString stringWithFormat:@"%@",[arrkent_fee objectAtIndex:1]];
        }
        else
        {
            lblDeliveryValueProcessed.text=[NSString stringWithFormat:@"$ %@",[arrkent_fee objectAtIndex:0]];
            lblkentFeeProcessedPoint.text=@"00";
            
        }
        
        
       
        lblUserNameProcessed.text=[dicRestaurentDetail2 objectForKey:@"first_name"];
  
        
        if ([NSString stringWithFormat:@"%@",[dicRestaurentDetail2  objectForKey:@"address"]].length==0 )
        {
            textVAddressProcessed.text=@"n/a";
        }
        else
        {
            textVAddressProcessed.text=[dicRestaurentDetail2  objectForKey:@"address"];
        }

        
    }
    else //for pending receipt
    {
        txtfTip.userInteractionEnabled=YES;

        viewReceiptBackWithPayProcessed.hidden=YES;
        viewReceiptBackWithPay.hidden=NO;
        
        
        
        int flag=0;
        for (int i=0;i<[arrForCArdList count]; i++)
        {
            if ([[[arrForCArdList objectAtIndex:i]objectForKey:@"is_default"] isEqualToString:@"1"])
            {
                // arrForCardList=[outputCard objectAtIndex:i];
                flag=1;
                
                NSString *str=[NSString stringWithFormat:@"%@",[[arrForCArdList objectAtIndex:i ] objectForKey:@"cc_number"]];
                NSString *code = [str substringFromIndex: [str length] -4];
                
                lblPayment.text=[NSString stringWithFormat:@"%@ *%@",[[arrForCArdList objectAtIndex:i ] objectForKey:@"cc_type"],code];
                
                //lblPayment.text=[[arrForCArdList objectAtIndex:i ] objectForKey:@"cc_type"];
                
                break;
            }
        }
        
        if (flag==0)
        {
            lblPayment.text=nil;
        }
        
        
        lblCompanyNmae.text=[dicRestaurentDetail2 objectForKey:@"restaurant_name"];
        lblPhone.text=[dicRestaurentDetail2 objectForKey:@"phone_number"];
        //lblPayment.text=[dicForCard objectForKey:@"cc_type"];
        
        
        NSArray *arrtax_amount=[[dicRestaurentDetail2 objectForKey:@"tax_amount"] componentsSeparatedByString:@"."];
        if (arrtax_amount.count==2)
        {
            lblTax.text=[NSString stringWithFormat:@"$ %@",[arrtax_amount objectAtIndex:0]];
            lblTaxPoint.text=[NSString stringWithFormat:@"%@",[arrtax_amount objectAtIndex:1]];
        }
        else
        {
            lblTax.text=[NSString stringWithFormat:@"$ %@",[arrtax_amount objectAtIndex:0]];
            lblTaxPoint.text=@"00";
            
        }
        
        
        
        NSArray *arrinvoicePrice=[[dicRestaurentDetail2 objectForKey:@"sub_total"] componentsSeparatedByString:@"."];
        if (arrinvoicePrice.count==2)
        {
            lblSubtotal.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
            lblSubtotalPoint.text=[NSString stringWithFormat:@"%@",[arrinvoicePrice objectAtIndex:1]];
        }
        else
        {
            lblSubtotal.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
            lblSubtotalPoint.text=@"00";
            
        }

        
        NSArray *arrinvoice_amount=[[dicRestaurentDetail2 objectForKey:@"invoice_amount"] componentsSeparatedByString:@"."];
        if (arrinvoice_amount.count==2)
        {
            lblTotal.text=[NSString stringWithFormat:@"$ %@",[arrinvoice_amount objectAtIndex:0]];
            lblTotalPoint.text=[NSString stringWithFormat:@"%@",[arrinvoice_amount objectAtIndex:1]];
        }
        else
        {
            lblTotal.text=[NSString stringWithFormat:@"$ %@",[arrinvoice_amount objectAtIndex:0]];
            lblTotalPoint.text=@"00";
            
        }
        
        NSArray *arrtip=[[dicRestaurentDetail2 objectForKey:@"tip"] componentsSeparatedByString:@"."];
        if (arrtip.count==2)
        {
            txtfTip.text=[NSString stringWithFormat:@"$ %@",[arrtip objectAtIndex:0]];
            lblTipPoint.text=[NSString stringWithFormat:@"%@",[arrtip objectAtIndex:1]];
        }
        else
        {
            txtfTip.text=[NSString stringWithFormat:@"$ %@",[arrtip objectAtIndex:0]];
            lblTipPoint.text=@"00";
            
        }

        
        NSArray *arrkent_fee=[[dicRestaurentDetail2 objectForKey:@"kent_fee"] componentsSeparatedByString:@"."];
        if (arrkent_fee.count==2)
        {
            lblDeliveryValue.text=[NSString stringWithFormat:@"$ %@",[arrkent_fee objectAtIndex:0]];
            lblkentFeePoint.text=[NSString stringWithFormat:@"%@",[arrkent_fee objectAtIndex:1]];
        }
        else
        {
            lblDeliveryValue.text=[NSString stringWithFormat:@"$ %@",[arrkent_fee objectAtIndex:0]];
            lblkentFeePoint.text=@"00";
            
        }
        
     
        lblUserName.text=[dicRestaurentDetail2 objectForKey:@"first_name"];
        
        if ([NSString stringWithFormat:@"%@",[dicRestaurentDetail2  objectForKey:@"address"]].length==0 )
        {
            textVAddress.text=@"n/a";
        }
        else
        {
            textVAddress.text=[dicRestaurentDetail2  objectForKey:@"address"];
        }


    }
    
    
    
}





#pragma mark-keyboard show and hide

-(void)keyboardShow:(UIView*)newView
{
    UIView *view=newView;
    
    [UIView animateWithDuration:.5
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         CGRect frame = view.frame;
                         frame.origin.y = newView.frame.origin.y-105;
                         frame.origin.x = newView.frame.origin.x;
                         view.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    
}

-(void)keyboardHide:(UIView*)newView
{
    UIView *view=newView;
    
    [UIView animateWithDuration:.5
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         CGRect frame = view.frame;
                         frame.origin.y = newView.frame.origin.y+105;
                         frame.origin.x = newView.frame.origin.x;
                         view.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
}







-(void)doPayment
{
    
    
    if([QAUtils IsNetConnected])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userdataKey"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        // NSLog(@"%@",arr);
        
        [DSBezelActivityView  newActivityViewForView:self.view];
        
        if ([[txtfTip.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
        {
            txtfTip.text=@"0";
        }
        else if ([txtfTip.text  isEqualToString:@"$"])
        {
            txtfTip.text=@"0";
        }
        
        txtfTip.text=[txtfTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        NSString *strTotal=[NSString stringWithFormat:@"%@.%@",[[lblTotal.text stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],[[lblTotalPoint.text stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        if (lblPayment.text.length==0 )
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"Select a card for fianl payment." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            
            
            
            
            
            for (int i=0;i<[arrForCArdList count]; i++)
            {
                if ([[[arrForCArdList objectAtIndex:i]objectForKey:@"cc_type"] isEqualToString:[[lblPayment.text componentsSeparatedByString:@" *"]objectAtIndex:0]]  )
                {
                    NSString *strCN=[[lblPayment.text componentsSeparatedByString:@"*"]objectAtIndex:1];
                    NSString *strCradlastNo=[[arrForCArdList objectAtIndex:i]objectForKey:@"cc_number"];
                    NSString *code = [strCradlastNo substringFromIndex: [strCradlastNo length] -4];
                    
                    if ([strCN isEqualToString:code])
                    {
                         dicForCard=[arrForCArdList objectAtIndex:i];
                        break;

                    }
                    
                   
                }
            }
            
            
            
            
            NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:[dicRestaurentDetail2 objectForKey:@"id"],@"receipt_id",
                                [[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],@"user_id",
                                [dicForCard objectForKey:@"id"],@"user_card_id",
                                txtfTip.text,@"tip_amount",
                                strTotal,@"total_amount",nil];
            
            
            
            NSString *str=[NSString stringWithFormat:@"http://netleondev.com/kentapi/user/processpayment"];
            
            NSURL *url =[NSURL URLWithString:str];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            
            [request addRequestHeader:@"Content-type" value:@"application/json"];
            [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
            
            [request setRequestMethod:@"POST"];
            request.delegate=self;
            request.allowCompressedResponse = NO;
            request.useCookiePersistence = NO;
            request.shouldCompressRequestBody = NO;
            request.timeOutSeconds=30;
            NSString *jsonRequest = [info JSONRepresentation];
            
            NSLog(@"jsonRequest is %@", jsonRequest);
            
            //NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
            
            
            
            NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setPostBody:[requestData mutableCopy]];
            
            [request startAsynchronous];
            

        }
        
        
    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }
    
    
}

#pragma mark- ASIHTTPRequest response methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSString *responseString = [request responseString];
    
    NSData *responseData = [request responseData];

    
    NSError *e=nil;
    
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&e];
    
    if (!jsonArray)
    {
        NSLog(@"errorNkl==%@ [e localizedDescription]=%@",e,[e localizedDescription]);
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"server error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        
            if ([strType isEqualToString:@"check for payment details"])
            {
                SBJSON *jsonParser=[[SBJSON alloc] init];
                id outputCard=[jsonParser objectWithString:responseString error:nil];
                
                if ([outputCard count]==0)
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please add you card detail in payment section." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    
                    [alert show];
                }
                else
                {
                    
                    for (int i=0;i<[outputCard count]; i++)
                    {
                        if ([[[outputCard objectAtIndex:i]objectForKey:@"is_default"] isEqualToString:@"1"])
                        {
                            dicForCard=[outputCard objectAtIndex:i];
                            break;
                        }
                    }
                    
                    
                    strType=@"do payment";
                    [self doPayment];
                }

            }
            else if ([strType isEqualToString:@"do payment"])
            {
                if([responseString isEqualToString:@"{\"success\":\"Payment Processed!\"}"])
                {
                    
                   // NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Payment Processed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    
                    LeaveAReviewVC *leavePay=[[LeaveAReviewVC alloc]initWithNibName:@"LeaveAReviewVC" bundle:nil];
                    leavePay.dicRestaurentDetails3=dicRestaurentDetail2;
                    [self.navigationController pushViewController:leavePay animated:YES];
                    
                    
                }
                else
                {
                    
                }
            }
            else if ([strType isEqualToString:@"getAllCards"])
            {
                SBJSON *jsonParser=[[SBJSON alloc] init];
                id outputCard=[jsonParser objectWithString:responseString error:nil];
                
                if ([outputCard count]==0)
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please add you card detail in payment section." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    
                    [alert show];
                }
                else
                {
                    
                    for (int i=0;i<[outputCard count]; i++)
                    {
                        if ([[[outputCard objectAtIndex:i]objectForKey:@"is_default"] isEqualToString:@"1"])
                        {
                          //  dicForCard=[outputCard objectAtIndex:i];
                            break;
                        }
                    }
                
                }
               

                
            }
        
        
            
        
        
    }
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark- TableView Datasource and delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrForCArdList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *str=[NSString stringWithFormat:@"%@",[[arrForCArdList objectAtIndex:indexPath.row ] objectForKey:@"cc_number"]];
    NSString *code = [str substringFromIndex: [str length] -4];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@ *%@",[[arrForCArdList  objectAtIndex:indexPath.row] objectForKey:@"cc_type"],code];
    
    if (IDIOM == IPAD) {
        cell.textLabel.font=[UIFont fontWithName:FONT_NAME_MAIN size:20];
    }else{
        cell.textLabel.font=[UIFont fontWithName:FONT_NAME_MAIN size:14];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *str=[NSString stringWithFormat:@"%@",[[arrForCArdList objectAtIndex:indexPath.row ] objectForKey:@"cc_number"]];
    NSString *code = [str substringFromIndex: [str length] -4];
    
    lblPayment.text=[NSString stringWithFormat:@"%@ *%@",[[arrForCArdList objectAtIndex:indexPath.row ] objectForKey:@"cc_type"],code];
    
    //lblPayment.text=[[arrForCArdList  objectAtIndex:indexPath.row] objectForKey:@"cc_type"];
    
    [modal hide];
}




#pragma mark- IB_Action
-(IBAction)btnBackDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnPayDidClicked:(id)sender
{
    
    strType=@"check for payment details";
    
    [self ckeckPayMentMode];
    
    

}

-(IBAction)btn_SelectCardDidClicked:(id)sender
{
    
#warning Change this to see a custom view
    BOOL useCustomView = NO;
    
    
    if (useCustomView)
    {
        UITableView *tblview;
        
        if ([arrForCArdList count]<8)
        {
            tblview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 44*[arrForCArdList count])];
            tblview.separatorColor=[UIColor clearColor];
        }
        else
        {
            tblview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 400)];
            tblview.separatorColor=[UIColor clearColor];
        }
        
       
        
        //tblview.backgroundColor = [UIColor redColor];
        tblview.layer.cornerRadius = 2.f;
        // tblview.layer.borderColor = [UIColor blackColor].CGColor;
        tblview.layer.borderWidth = 0.5f;
        
        tblview.delegate=self;
        tblview.dataSource=self;
        
        modal = [[RNBlurModalView alloc] initWithView:tblview];
        
        
        
    }
    else
    {
        
        UITableView *tblview;
        
        if ([arrForCArdList count]<8)
        {
            if (IDIOM == IPAD) {
                tblview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 55*[arrForCArdList count])];
            }else{
                tblview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 44*[arrForCArdList count])];
                tblview.separatorColor=[UIColor clearColor];
            }
        }
        else
        {
            tblview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 400)];
            tblview.separatorColor=[UIColor clearColor];
        }
        
        tblview.separatorColor=[UIColor clearColor];
        // tblview.backgroundColor = [UIColor redColor];
        tblview.layer.cornerRadius = 2.f;
        // tblview.layer.borderColor = [UIColor blackColor].CGColor;
        tblview.layer.borderWidth = 0.5f;
        
        tblview.delegate=self;
        tblview.dataSource=self;
        
        modal = [[RNBlurModalView alloc] initWithView:tblview];
        
        modal.defaultHideBlock = ^{
            NSLog(@"Code called after the modal view is hidden");
        };
    }
    //    modal.dismissButtonRight = YES;
    [modal show];
}



-(void)ckeckPayMentMode
{
    
    
    if([QAUtils IsNetConnected])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userdataKey"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        // NSLog(@"%@",arr);
        
        
        
        [DSBezelActivityView  newActivityViewForView:self.view];
        
        NSString *str=[NSString stringWithFormat:@"http://netleondev.com/kentapi/user/creditcards/userid/%@",[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"]];
        
        NSURL *url =[NSURL URLWithString:str];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"Content-type" value:@"application/json"];
        [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
        
        [request setRequestMethod:@"GET"];
        request.delegate=self;
        request.allowCompressedResponse = NO;
        request.useCookiePersistence = NO;
        request.shouldCompressRequestBody = NO;
        request.timeOutSeconds=30;
        
        [request startAsynchronous];
        
        
        
    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
