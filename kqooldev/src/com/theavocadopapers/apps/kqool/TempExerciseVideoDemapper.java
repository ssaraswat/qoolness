package com.theavocadopapers.apps.kqool;

import java.io.IOException;
import java.util.List;

import javax.servlet.jsp.JspWriter;

import com.theavocadopapers.apps.kqool.entity.Exercise;
import com.theavocadopapers.apps.kqool.entity.ExerciseVideo;
import com.theavocadopapers.apps.kqool.entity.VideoToExerciseMapping;

public class TempExerciseVideoDemapper {



	public static void deMap(final JspWriter out) throws IOException {
		final List allVidExMappings=VideoToExerciseMapping.getAll();
		VideoToExerciseMapping mapping;
		Exercise exercise=null;
		ExerciseVideo vid=null;
		int vidId;
		int exId;
		String msg=null;
		int exNull=0;
		int vidNull=0;
		int stored=0;
		for (int i=0; i<allVidExMappings.size(); i++) {
			mapping=(VideoToExerciseMapping)allVidExMappings.get(i);
			vidId=mapping.getExerciseVideoId();
			exId=mapping.getExerciseId();
			try {
				exercise=Exercise.getById(exId);
			}
			catch (final Exception e) {}
			try {
				vid=ExerciseVideo.getById(vidId);
			}
			catch (final Exception e) {}
			if (exercise==null) {
				msg="Mapping of Exercise with id "+exId+" to video  with id "+vidId+" skipped because Exercise was null.";
				exNull++;
			}
			else if (vid==null) {
				msg="Mapping of Exercise with id "+exId+" to video  with id "+vidId+" skipped because ExerciseVideo was null.";
				vidNull++;
			}
			else {
				exercise.setExerciseVideoId(vidId);
				exercise.store();
				msg="Exercise '"+exercise.getName()+"' (id "+exercise.getId()+") set to video '"+vid.getName()+"' (id "+vid.getId()+") and stored.";
				stored++;
			}
			System.out.println(msg);
			out.println(msg+"<br/>");
			out.flush();
		}
		msg=""+stored+" Exercises were stored with exerciseVideoIds; "+exNull+" were skipped because the Exercise was null; "+vidNull+" were skilled because the ExerciseVideo was null.";
		System.out.println(msg);
		out.println(msg+"<br/>");
	}

}
