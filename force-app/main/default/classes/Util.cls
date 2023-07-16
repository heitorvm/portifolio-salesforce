public with sharing class Util {
    
    // Method to execute http request
    public static HttpResponse executeHttpRequest(String endPoint, String method, Map<String, String> headers, String body, Integer timeout){
        HttpRequest request = new HttpRequest();
        Http http = new Http();

        request.setEndpoint(endPoint);
        request.setMethod(method);
        request.setTimeout(timeout);

        if(method == 'POST' || method == 'PUT')
            request.setBody(body != null ? body : '');
        else if(body != null)
            request.setBody(body);

        if(headers != null){
            for(String nomeHeader : headers.keySet()){
                request.setHeader(nomeHeader, headers.get(nomeHeader));
            }
        }

        return http.send(request);
    }

    // Method to validate CPF
    public static Boolean validateCPF(String cpf){
        cpf = removeSpecialCharacter(cpf);

        if(cpf == '00000000000' || cpf == '11111111111' || cpf == '22222222222' || cpf == '33333333333' || cpf == '44444444444' || cpf == '55555555555' || cpf == '66666666666' || cpf == '77777777777' || cpf == '88888888888' || cpf == '99999999999' || cpf.length() != 11) return false;

        Integer soma, resto;
        soma = 0;

        for(Integer i = 1; i <= 9; i++){
            soma = soma + Integer.valueOf(cpf.substring(i-1, i)) * (11 - i);
        }
        resto = Math.mod(soma,11);
        if (resto == 10 || resto == 11 || resto < 2) {
            resto = 0;
        } else {
            resto = 11 - resto;
        }
        if (resto != Integer.valueof(cpf.substring(9, 10))) {
            return false;
        }

        soma = 0;

        for(Integer i = 1; i <= 10; i++){
            soma = soma + Integer.valueOf(cpf.substring(i-1, i)) * (12 - i);
        }
        resto = Math.mod(soma,11);
        if (resto == 10 || resto == 11 || resto < 2) {
            resto = 0;
        } else {
            resto = 11 - resto;
        }
        if (resto != Integer.valueof(cpf.substring(10, 11))) {
            return false;
        }
        
        return true;
    }
    
    // Method to validate CNPJ
    public static Boolean validateCNPJ(String cnpj){
        cnpj = removeSpecialCharacter(cnpj);

        if (cnpj.equals('00000000000000') || cnpj.equals('11111111111111') || cnpj.equals('22222222222222') || cnpj.equals('33333333333333') || cnpj.equals('44444444444444') || cnpj.equals('55555555555555') || cnpj.equals('66666666666666') || cnpj.equals('77777777777777') || cnpj.equals('88888888888888') || cnpj.equals('99999999999999') || (cnpj.length() != 14)) return false;

        Integer sm, i, r, num, peso, dig13, dig14;
        List<String> cnpjString = CNPJ.split('');
        sm = 0;
        peso = 2;
        for (i=11; i>=0; i--) {
            num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            peso = peso + 1;
            if (peso == 10) peso = 2;
        }

        r = math.mod(sm, 11);
        if ((r == 0) || (r == 1)) dig13 = 0;
        else dig13 = Integer.valueOf(11-r);

        sm = 0;
        peso = 2;
        for (i=12; i>=0; i--) {
            num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            peso = peso + 1;
            if (peso == 10) peso = 2;
        }

        r = math.mod(sm, 11);
        if ((r == 0) || (r == 1)) dig14 = 0;
        else dig14 = Integer.valueOf(11-r);

        if (dig13 == Integer.valueOf(cnpjString[12]) && dig14 == Integer.valueOf(cnpjString[13])) return true;
        else return false ;
    }

    // Method to create a guid
    public static String createGUID(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }

    // Method to remove all special character in strings
    private static String removeSpecialCharacter(String value){
        return value.replaceAll('[^a-zA-Z0-9\\s+]', '');
    }

}