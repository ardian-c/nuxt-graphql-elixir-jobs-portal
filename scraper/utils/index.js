
module.exports = {
  sluggify: title => {
    var random = Math.floor(Date.now() / 1000);
    var slug = "";
    // Change to lower case
    var titleLower = title.toLowerCase();
    titleLower.replace(/\s\s+/g,' ');
    titleLower.replace(/\//g, '');

    // Letter "e"
    slug = titleLower.replace(/e|é|è|ẽ|ë|ẻ|ẹ|ê|ế|ề|ễ|ể|ệ/gi, "e");
    // Letter "a"
    slug = slug.replace(/a|á|à|ã|ả|ạ|ă|ắ|ằ|ẵ|ẳ|ặ|â|ấ|ầ|ẫ|ẩ|ậ/gi, "a");
    // Letter "o"
    slug = slug.replace(/o|ó|ò|õ|ỏ|ọ|ô|ố|ồ|ỗ|ổ|ộ|ơ|ớ|ờ|ỡ|ở|ợ/gi, "o");
    // Letter "u"
    slug = slug.replace(/u|ú|ù|ũ|ủ|ụ|ư|ứ|ừ|ữ|ử|ự/gi, "u");
    // Letter "d"
    slug = slug.replace(/đ/gi, "d");
    // letter 'ç'
    slug = slug.replace(/ç/gi, "c");

    // titleLower.replace(/[^a-zA-Z0-9]/g, '-');
    slug = slug.replace(/[&\/\\#,+()$~%.'":*?<>{}]/g,'-');

    // Trim the last whitespace
    slug = slug.replace(/\s*$/g, "");
    // Change whitespace to "-"
    slug = slug.replace(/\s+/g, "-");

    return slug + "-" + random;
  }
};