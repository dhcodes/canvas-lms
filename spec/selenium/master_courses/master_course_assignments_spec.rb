#
# Copyright (C) 2017 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

require_relative '../common'
require_relative '../helpers/blueprint_common'

describe "master courses - assignment locking" do
  include_context "in-process server selenium tests"
  include BlueprintCourseCommon

  before :once do
    Account.default.enable_feature!(:master_courses)

    @course = course_factory(:active_all => true)
    @template = MasterCourses::MasterTemplate.set_as_master_course(@course)
    @assignment = @course.assignments.create!(:title => "blah", :description => "bloo")
    @tag = @template.create_content_tag_for!(@assignment)
  end

  before :each do
    user_session(@teacher)
  end

  it "should show unlocked button on index page for unlocked assignment" do
   get "/courses/#{@course.id}/assignments"
   expect(f('[data-view="lock-icon"] i.icon-blueprint')).to be_displayed
  end

  it "should show locked button on index page for locked assignment" do
    # restrict something
    @tag.update(restrictions: {content: true})
    get "/courses/#{@course.id}/assignments"
    expect(f('[data-view="lock-icon"] i.icon-blueprint-lock')).to be_displayed
  end
end
