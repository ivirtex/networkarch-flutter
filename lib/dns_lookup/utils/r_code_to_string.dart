String rCodeToString(int rcode) {
  switch (rcode) {
    case 0:
      return 'NOERROR';
    case 1:
      return 'FORMERR';
    case 2:
      return 'SERVFAIL';
    case 3:
      return 'NXDOMAIN';
    case 4:
      return 'NOTIMP';
    case 5:
      return 'REFUSED';
    case 6:
      return 'YXDOMAIN';
    case 7:
      return 'YXRRSET';
    case 8:
      return 'NXRRSET';
    case 9:
      return 'NOTAUTH';
    case 10:
      return 'NOTZONE';
    case 11:
      return 'RCODE_11';
    case 12:
      return 'RCODE_12';
    case 13:
      return 'RCODE_13';
    case 14:
      return 'RCODE_14';
    case 15:
      return 'RCODE_15';
  }

  return 'RCODE_$rcode';
}
