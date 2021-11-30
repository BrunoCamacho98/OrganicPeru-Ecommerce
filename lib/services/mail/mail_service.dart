import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
// Models
import 'package:organic/models/sale.dart';
// Constant
import 'package:organic/constants/globals.dart' as global;

mail(Sale sales, String code) async {
  String username = 'OrganicPeruTest@gmail.com';
  String password = 'organic2021';

  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'OrganicPerú')
    ..recipients.add(sales.email)
    ..subject = 'Recibo de pago ${DateTime.now()}'
    ..text = 'Compras en OrganicPeru'
    ..html = getVoucher(sales, code);

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

  var connection = PersistentConnection(smtpServer);
  await connection.close();
}

String getVoucher(Sale sale, String code) {
  var dateNow = DateTime.now();
  var dateNextMonth = DateTime(dateNow.year, dateNow.month + 1, dateNow.day);

  var voucherDetails = getRowToVoucher();

  const fontFamily =
      "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif";

  var voucher = '';

  voucher +=
      '<div style="padding: 15px; border: 1px #dcdcdc solid; width: 800px; background: white; box-shadow: 0px 0px 8px rgba(0,0,0,.1); font-family:${fontFamily}"><div><div><div><ul style="list-style: none; padding: 0;"> <strong><li><span style="font-size: 25px; color: #0C9869"> Organic - Perú </span></li></strong> <li><span>${sale.email}</span></li></ul></div></div></div> <div class="article o_report_layout_clean o_company_NewId_0x7f64f8779fd0_layout"> <div class="pt-5"> <div class="address row"> <div name="address" class="col-md-5 ml-auto"> <address> <address class="mb-0" itemscope="itemscope" itemtype="http://schema.org/Organization"> <div itemprop="address" itemscope="itemscope" itemtype="http://schema.org/PostalAddress"> <div class="d-flex align-items-baseline"> <span class="w-100 o_force_ltr" itemprop="streetAddress">${sale.getAdress()}<br>Perú</span> </div> </div> </address> </address> </div> </div> <div class="page"> <h2> <span>Factura</span> <span>${code}</span> </h2> <div id="informations" class="row mt32 mb32"> <div class="col-auto mw-100 mb-2" name="invoice_date"> <strong>Fecha de factura:</strong> <p class="m-0">${getDate(dateNow)}</p> </div> <div class="col-auto mw-100 mb-2" name="due_date"> <strong>Fecha de vencimiento:</strong> <p class="m-0">${getDate(dateNextMonth)}</p> </div> </div>';

  voucher +=
      '<table style="margin: 15px 0px; padding: 0px; border-spacing: 0; width: 90%;"> <thead> <tr> <th style="text-align: left; border-bottom: 1px #118961 solid; padding: 8px; font-size: 14px;color: #17c188"><span>Descripción</span></th> <th style="text-align: left; border-bottom: 1px #118961 solid; padding: 8px; font-size: 14px;color: #17c188; text-align: center"><span>Cantidad</span></th> <th style="text-align: left; border-bottom: 1px #118961 solid; padding: 8px; font-size: 14px;color: #17c188; text-align: center"><span>Precio Unitario</span></th> <th style="text-align: left; border-bottom: 1px #118961 solid; padding: 8px; font-size: 14px;color: #17c188; text-align: center"><span>Impuestos</span></th> <th style="text-align: left; border-bottom: 1px #118961 solid; padding: 8px; font-size: 14px;color: #17c188; text-align: center"> <span>Cantidad</span> </th> </tr> </thead> <tbody class="invoice_tbody">${voucherDetails}<tbody><tr class="border-black o_subtotal" style=""> <td style="padding: 5px"><strong>Subtotal</strong></td> <td style="padding: 5px; text-align: right"> <span class="oe_currency_value">${sale.getTotal()}</span> </td> </tr> <tr style=""> <td style="padding: 5px"><span class="text-nowrap">Impuesto (15%)</span></td> <td style="padding: 5px; text-align: right"> <span class="text-nowrap">${sale.getTax()}</span> </td> </tr><tr ><td style="padding: 5px"><strong>Total</strong></td><td style="padding: 5px; text-align:right"> <span class="text-nowrap"><span > ${sale.getTotalWithTax()}</span></span> </td> </tr> </tbody></table>';

  voucher +=
      '</div> </div> </div> <p> Please use the following communication for your payment : <b><span>${code}</span></b> </p> <p name="payment_term"> <span>Payment terms: 30 Days</span> </p><div class="footer o_clean_footer o_company_NewId_0x7f64f8779fd0_layout"><div class="row mt8"><div class="col-3"></div><div class="col-4 text-right"><span class="company_address"><address class="mb-0" itemscope="itemscope" itemtype="http://schema.org/Organization"><div itemprop="address" itemscope="itemscope" itemtype="http://schema.org/PostalAddress"><div class="d-flex align-items-baseline"><span>Perú</span></div></div> </address> </span></div> <div class="col-4"></div> <div class="col-1"> </div> </div> </div> </div>';

  return voucher;
}

String getDate(DateTime date) {
  return (date.day < 10 ? "0" : "") +
      date.day.toString() +
      '/' +
      (date.month < 10 ? "0" : "") +
      date.month.toString() +
      '/' +
      date.year.toString();
}

getRowToVoucher() {
  var rows = '';

  for (var detailsale in global.detailSales) {
    rows += '<tr>';
    rows +=
        '<td style="padding: 8px; font-size: 12px;border-bottom: 1px #118961 solid;">${detailsale.product!.name!}</td>  <td style="padding: 8px; font-size: 12px;border-bottom: 1px #118961 solid; text-align: center"> <span> ${detailsale.amount}</span> </td> <td style="padding: 8px; font-size: 12px;border-bottom: 1px #118961 solid; text-align: center"> ${detailsale.getTotalFormatted()} </td> <td style="padding: 8px; font-size: 12px;border-bottom: 1px #118961 solid; text-align:center"> <span>15%</span> </td> <td style="padding: 8px; font-size: 12px;border-bottom: 1px #118961 solid; text-align: center"> <span>${detailsale.getWithTax()}</span> </td>';
    rows += '</tr>';
  }

  return rows;
}
