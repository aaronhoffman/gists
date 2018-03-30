'use strict';

var users = require("./users.json");
var fs = require("fs");
var path = require("path");
var request = require("sync-request");
var { execSync } = require("child_process");

var gistSync = function () {
    var self = this;

    self.syncUser = function (username) {
        self.ensureDirs(username);

        var gists = self.getGists(username);

        gists.forEach(gist => {
            self.syncGist(username, gist.id);
        });
    };

    self.ensureDirs = function (username) {
        // ensure gists dir exists
        var gistsDir = path.join(process.cwd(), "gists");
        if (!fs.existsSync(gistsDir)) {
            fs.mkdirSync(gistsDir);
        }

        // ensure dir exists for user
        var userDir = path.join(gistsDir, username);
        if (!fs.existsSync(userDir)) {
            fs.mkdirSync(userDir);
        }
    }

    self.getGists = function (username) {
        var req = request("GET", "https://api.github.com/users/" + username + "/gists", { headers: { "user-agent": "gist-sync" } });
        var gists = JSON.parse(req.getBody("utf8"));

        return gists;
    }

    self.syncGist = function (username, gistId) {
        // sync each gist into a separate folder `username/gist-id`
        // ensure the directory exists, delete all existing content if any, clone the repo, delete the `.git` folder
        var gistDir = path.join(process.cwd(), "gists", username, gistId);

        if (fs.existsSync(gistDir)) {
            self.rmdirSync(gistDir);
        }

        fs.mkdirSync(gistDir);

        execSync("git clone https://gist.github.com/" + gistId + " " + gistDir, { cwd: process.cwd() });

        var gistDirGitDir = path.join(gistDir, ".git");
        self.rmdirSync(gistDirGitDir);
    }

    self.rmdirSync = function (dir) {
        if (fs.existsSync(dir)) {
            fs.readdirSync(dir).forEach(function (file, index) {
                var curPath = dir + "/" + file;
                if (fs.lstatSync(curPath).isDirectory()) {
                    self.rmdirSync(curPath);
                } else {
                    fs.unlinkSync(curPath);
                }
            });
            fs.rmdirSync(dir);
        }
    }
};

var gs = new gistSync();

users.forEach(u => {
    gs.syncUser(u);
});
