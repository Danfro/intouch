/*
 * Copyright (C) 2025  Sander Klootwijk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * intouch is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: topicPage

    property bool topicLoading: false
    property string topicSlug: ""
    property int currentPage: 0
    property int pageCount: 0
    property int currentPost: 0
    property int postCount: 0

    Component.onCompleted: fetchTopic(topicSlug, 1);

    header: PageHeader {
        id: topicPageHeader
        
        Label {
            id: topicPageHeaderTitle

            anchors {
                left: parent.left
                leftMargin: units.gu(5)
                right: parent.right
                rightMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
            }

            text: ""

            textFormat: Text.PlainText
            textSize: text.length * units.gu(1.25) > width ? Label.Medium : Label.Large
            wrapMode: Text.WordWrap
            maximumLineCount: 2
        }
    }

    ProgressBar {
        visible: topicLoading

        anchors {
            top: topicPageHeader.bottom
            left: parent.left
            right: parent.right
        }

        indeterminate: true
    }

    ListModel {
        id: topicListModel
    }

    ListView {
        id: topicListView

        anchors {
            fill: parent
            topMargin: topicPageHeader.height
            bottomMargin: paginationBar.height
        }

        model: topicListModel
        delegate: PostListItem {}
        cacheBuffer: 1000
        clip: true

        onAtYEndChanged: {
            if (atYEnd == true) {
                if (currentPage < pageCount && !topicLoading) {
                    fetchTopic(topicSlug, currentPage + 1);
                }
            }
        }

        onContentHeightChanged: findCurrentPost()
        onContentYChanged: findCurrentPost()

        function findCurrentPost() {
            var currentIndexY;

            if (topicListView.contentHeight < topicListView.height) {
                currentIndexY = contentY + topicListView.contentHeight - units.gu(1);
            }
            else if (currentPage == pageCount && topicListView.atYEnd) {
                currentIndexY = contentY + topicListView.height - units.gu(1);
            }
            else {
                currentIndexY = contentY + topicListView.height / 2;
            }

            var currentIndex = topicListView.indexAt(1, currentIndexY) + 1;
            
            if (currentIndex <= 0) {
                currentIndex = postCount;
            }

            currentPost = currentIndex;
        }
    }

    Scrollbar {
        id: topicScrollbar

        flickableItem: topicListView
        align: Qt.AlignTrailing
    }

    Item {
        id: paginationBar

        width: parent.width
        height: units.gu(4)

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        Rectangle {
            width: parent.width
            height: units.dp(1)

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.top
            }
            
            color: theme.palette.normal.base
        }

        Row {
            anchors.fill: parent

            spacing: (parent.width - (upButton.width + postsLabel.width + downButton.width)) / 4

            Item {
                width: units.dp(1)
                height: units.gu(4)
            }

            MouseArea {
                id: upButton

                width: units.gu(4)
                height: units.gu(4)

                enabled: !topicListView.atYBeginning
                onClicked: topicListView.positionViewAtBeginning()

                Icon {
                    width: units.gu(2.5)
                    height: units.gu(2.5)

                    anchors.centerIn: parent

                    color: topicListView.atYBeginning ? theme.palette.disabled.baseText : theme.palette.normal.baseText
                    name: "go-up"
                }
            }

            Label {
                id: postsLabel

                width: units.gu(14)

                anchors.verticalCenter: parent.verticalCenter

                horizontalAlignment: Text.AlignHCenter                
                text: postCount == 0 ? "" : "Post " + currentPost + " from " + postCount
            }

            MouseArea {
                id: downButton

                width: units.gu(4)
                height: units.gu(4)

                enabled: !topicListView.atYEnd
                onClicked: topicListView.positionViewAtEnd()

                Icon {
                    width: units.gu(2.5)
                    height: units.gu(2.5)

                    anchors.centerIn: parent

                    color: topicListView.atYEnd ? theme.palette.disabled.baseText : theme.palette.normal.baseText
                    name: "go-down"
                }
            }

            Item {
                width: units.dp(1)
                height: units.gu(4)
            }
        }
    }

    // Fetch topic
    function fetchTopic(slug, page) {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://forums.ubports.com/api/topic/" + slug + "?page=" + page, true);

        topicLoading = true;

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    let data = JSON.parse(xhr.responseText);
                    let posts = data.posts;

                    topicPageHeaderTitle.text = data.titleRaw;
                    currentPage = page;
                    pageCount = data.pagination.pageCount;
                    postCount = data.postcount;

                    for (let i = 0; i < posts.length; i++) {
                        topicListModel.append({
                            "username": posts[i].user.username,
                            "picture": posts[i].user.picture == null ? "" : "https://forums.ubports.com/" + posts[i].user.picture,
                            "username": posts[i].user.username,
                            "bgColor": posts[i].user["icon:bgColor"],
                            "usernameText": posts[i].user["icon:text"], 
                            "content": posts[i].content.replace(/<img /g, '<img width="' + units.gu(35) + '" height="auto" ').replace(/class="not-responsive emoji /g, ' width="' + units.gu(1.75) + '" height="auto" class="not-responsive emoji ').replace(/<a /g, '<a style="color: ' + theme.palette.normal.activity + ';"').replace(/src="\/assets/g, 'src="https://forums.ubports.com/assets'),
                            "timestampISO": posts[i].timestampISO,
                            "postIndex": posts[i].index,
                            "votes": posts[i].votes,
                            "pid": posts[i].pid,
                            "slug": posts[i].slug
                        });
                    }
                    
                    console.log("Topic fetched successfully, page " + currentPage + "/" + pageCount);

                    if (currentPage < pageCount) {
                        fetchTopic(topicSlug, currentPage + 1);
                        return;
                    }

                    topicLoading = false;

                    return;

                } else {
                    topicLoading = false;

                    console.log("Failed to fetch topic:", xhr.status, xhr.statusText);
                }
            }
        };

        xhr.send();
    }
}