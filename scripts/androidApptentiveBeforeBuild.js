module.exports = function(ctx) {
    // make sure android platform is part of build
    if (ctx.opts.platforms.indexOf('android') < 0) {
        return;
    }
    var fs = ctx.requireCordovaModule('fs'),
        path = ctx.requireCordovaModule('path'),
        deferral = ctx.requireCordovaModule('q').defer();

    var propertiesFileLocation = path.join(ctx.opts.projectRoot, 'platforms/android/project.properties');

    fs.stat(propertiesFileLocation, function(err,stats) {
        if (err) {
                deferral.reject('Operation failed. Properties file not found: ' + propertiesFileLocation);
        } else {
            var propertiesContent = fs.readFileSync(propertiesFileLocation, 'utf-8');
            var oldContent = propertiesContent;
            for (var i = 14; i < 28; ++i) {
                propertiesContent = propertiesContent.replace("target=android-" + i, "target=android-28");
            }
            if (oldContent !== propertiesContent) {
                console.log("WARNING: Apptentive SDK has overriden Android platform target to android-28!");
                fs.writeFileSync(propertiesFileLocation, propertiesContent);
            }
            deferral.resolve();
        }
    });

    return deferral.promise;
};